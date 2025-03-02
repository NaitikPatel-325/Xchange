import mongoose from 'mongoose';
import Transaction from '../models/Transaction.js';

export const getdata = (req,res) => {
    res.send("hello");
}

export const getUserTransactions = async (req, res) => {
    try {
      const { userId } = req.params;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: 'User ID is required'
        });
      }

      // Fetch transactions and populate user1 and user2 with User data
      const transactions = await Transaction.find({
        $or: [{ user1: userId }, { user2: userId }]
      })
        .populate('user1', 'email name') // Populate user1 with email and name (adjust fields as needed)
        .populate('user2', 'email name') // Populate user2 with email and name
        .select('user1 user2 user1Email user2Email barterListing status timestamp offeredItem requestedItem');

      // Format the data for Flutter
      const formattedTransactions = transactions.map(transaction => ({
        id: transaction._id.toString(),
        title: `${transaction.offeredItem?.title || 'Untitled'} for ${transaction.requestedItem?.title || 'Untitled'}`,
        status: transaction.status,
        user1Email: transaction.user1Email || transaction.user1?.email || 'Unknown', // Fallback to populated email
        user2Email: transaction.user2Email || transaction.user2?.email || 'Unknown',
        user1Name: transaction.user1?.name || 'Unknown', // Populated name
        user2Name: transaction.user2?.name || 'Unknown', // Populated name
      }));

      res.status(200).json({
        success: true,
        data: formattedTransactions
      });
    } catch (error) {
      console.error('Error in getUserTransactions:', error);
      res.status(500).json({
        success: false,
        message: 'Server error while fetching transactions',
        error: error.message
      });
    }
  };

export const proposeTransaction = async (req, res) => {
    try {
      const {
        requestorId,
        requestorEmail,
        recipientId,
        recipientEmail,
        listingId,
        offeredItem,
        requestedItem,
        status
      } = req.body;
      console.log('Received data:', JSON.stringify(req.body, null, 2));
      // Validate required fields
      if (!requestorId || !recipientId || !listingId) {
        return res.status(400).json({
          success: false,
          message: 'Missing required fields: requestorId, recipientId, or barterListingId'
        });
      }

      // Ensure IDs are valid ObjectIds
      if (
        !mongoose.Types.ObjectId.isValid(requestorId) ||
        !mongoose.Types.ObjectId.isValid(recipientId) ||
        !mongoose.Types.ObjectId.isValid(listingId)
      ) {
        return res.status(400).json({
          success: false,
          message: 'Invalid ObjectId format for requestorId, recipientId, or barterListingId'
        });
      }

      let transaction = await Transaction.findOne({
        barterListing: listingId,
        status: 'pending'
      });

      if (transaction) {
        transaction.user2 = requestorId;
        transaction.status = 'active';
        // Store the offered and requested items if your model supports it
        transaction.offeredItem = offeredItem;
        transaction.requestedItem = requestedItem;
      } else {
        transaction = new Transaction({
          user1: recipientId,
          user2: requestorId,
          barterListing: listingId,
          status: 'active',
          timestamp: new Date(),
          offeredItem: offeredItem,
          requestedItem: requestedItem,
          user1Email: recipientEmail,
          user2Email: requestorEmail
        });
      }
      await transaction.save();

      res.status(201).json({
        success: true,
        message: 'Exchange proposal accepted successfully!',
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


export const updateTransactionStatus = async (req, res) => {
    try {
      const transactionId = req.params.id;
      const { status } = req.body;

      // Validate inputs
      if (!transactionId) {
        return res.status(400).json({
          success: false,
          message: 'Transaction ID is required'
        });
      }

      if (!status || !['Active', 'Pending', 'Completed'].includes(status)) {
        return res.status(400).json({
          success: false,
          message: 'Valid status (Active, Pending, or Completed) is required'
        });
      }

      // Assuming you have a Transaction model
      const transaction = await Transaction.findById(transactionId);

      if (!transaction) {
        return res.status(404).json({
          success: false,
          message: 'Transaction not found'
        });
      }

      // Update the transaction status
      transaction.status = status;
      await transaction.save();

      return res.status(200).json({
        success: true,
        message: 'Transaction status updated successfully',
        data: transaction
      });

    } catch (error) {
      console.error('Error updating transaction status:', error);
      return res.status(500).json({
        success: false,
        message: 'Failed to update transaction status',
        error: error.message
      });
    }
  };
