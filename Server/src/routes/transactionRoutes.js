import express from "express";
const router = express.Router();
import { proposeTransaction,getUserTransactions } from '../controller/proposeTransaction.js';

router.post('/propose', proposeTransaction);
router.get('/user/:userId', getUserTransactions);

export default router;
