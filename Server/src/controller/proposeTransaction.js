import mongoose from 'mongoose';
import Transaction from '../models/Transaction.js';

export const getdata = (req,res) => {
    res.send("hello");
}

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
