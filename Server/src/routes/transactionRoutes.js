import express from "express";
const router = express.Router();
import { proposeTransaction,getUserTransactions,updateTransactionStatus } from '../controller/proposeTransaction.js';

router.post('/propose', proposeTransaction);
router.get('/user/:userId', getUserTransactions);
router.put('/:id',updateTransactionStatus);
export default router;
