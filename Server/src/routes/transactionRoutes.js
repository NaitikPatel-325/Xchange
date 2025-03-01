import express from "express";
const router = express.Router();
import { proposeTransaction } from '../controller/proposeTransaction.js';

router.post('/propose', proposeTransaction);

export default router;
