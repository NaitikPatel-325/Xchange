import Transaction from '../models/Transaction.js';

export const proposeTransaction = async (req, res) => {
  try {
    const {
      requestorId,
      requestorEmail,
      recipientId,
      recipientEmail,
      barterListingId,
      offeredItem,
      requestedItem
    } = req.body;

    if (!requestorId || !recipientId || !barterListingId) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: requestorId, recipientId, or barterListingId'
      });
    }

    let transaction = await Transaction.findOne({
      barterListing: barterListingId,
      status: 'pending'
    });

    if (transaction) {
      transaction.user2 = requestorId;
      transaction.status = 'active';
      await transaction.save();
    } else {
      transaction = new Transaction({
        user1: recipientId,
        user2: requestorId,
        barterListing: barterListingId,
        status: 'active',
        timestamp: new Date()
      });
      await transaction.save();
    }

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
