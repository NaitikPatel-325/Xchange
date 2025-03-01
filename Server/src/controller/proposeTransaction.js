import Transaction from '../models/Transaction';
import Notification from '../models/Notification';
import User from '../models/User';

exports.proposeTransaction = async (req, res) => {
  try {
    const {
      requestorId,       // User2 who is proposing/accepting
      requestorEmail,
      recipientId,      // User1 who listed the barter
      recipientEmail,
      barterListingId,  // ID of the barter listing
      offeredItem,      // What User2 is offering
      requestedItem     // What User2 is requesting (from User1's listing)
    } = req.body;

    // Validate required fields
    if (!requestorId || !recipientId || !barterListingId) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: requestorId, recipientId, or barterListingId'
      });
    }

    // Check if a transaction already exists for this barter listing
    let transaction = await Transaction.findOne({
      barterListing: barterListingId,
      status: 'pending'
    });

    if (transaction) {
      // If transaction exists, update it to 'active' since User2 is accepting
      transaction.user2 = requestorId;
      transaction.status = 'active';
      await transaction.save();
    } else {
      // Create a new transaction if it doesn't exist
      transaction = new Transaction({
        user1: recipientId,     // Original lister
        user2: requestorId,     // Proposer/Acceptor
        barterListing: barterListingId,
        status: 'active',       // Set to active since this is an acceptance
        timestamp: new Date()
      });
      await transaction.save();
    }

    // Create notifications
    const requestorNotification = new Notification({
      userId: requestorId,
      type: 'transaction_accepted',
      message: `You successfully proposed an exchange for ${requestedItem.title}`,
      relatedId: transaction._id,
      read: false,
      createdAt: new Date()
    });

    const recipientNotification = new Notification({
      userId: recipientId,
      type: 'transaction_proposed',
      message: `${requestorEmail} has accepted your barter listing for ${offeredItem.title}`,
      relatedId: transaction._id,
      read: false,
      createdAt: new Date()
    });

    await Promise.all([
      requestorNotification.save(),
      recipientNotification.save()
    ]);

    // Update unread notification counts
    await Promise.all([
      User.findByIdAndUpdate(requestorId, { $inc: { unreadNotifications: 1 } }),
      User.findByIdAndUpdate(recipientId, { $inc: { unreadNotifications: 1 } })
    ]);

    res.status(201).json({
      success: true,
      message: 'Exchange proposal accepted successfully! Transaction is now active.',
      data: {
        transactionId: transaction._id,
        status: transaction.status
      }
    });
  } catch (error) {
    console.error('Error in proposeTransaction:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while processing transaction proposal',
      error: error.message
    });
  }
};
