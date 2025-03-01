// routes/transactionRoutes.js
import express from "express";
const router = express.Router();
import { proposeTransaction } from '../controller/proposeTransaction.js'; // Adjust path as needed

router.post('/propose', proposeTransaction);

export default router;
