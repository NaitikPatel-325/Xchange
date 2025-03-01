import express from "express";
const router = express.Router();
import { getdata,proposeTransaction } from '../controller/proposeTransaction.js';

router.post('/propose', proposeTransaction);
router.get('/get',getdata);
export default router;
