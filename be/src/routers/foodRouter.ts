import { Router } from 'express';
import { createFoodPost, getFoodPost, getFoods } from '../controllers/foodController';
import upload from '../config/multer';

const foodRouter: Router = Router();

// Matches with /api/foods
foodRouter.route('/')
  .get(getFoods)
  .post(upload.array('images', 5), createFoodPost);
foodRouter.route('/post/:id').get(getFoodPost);
export default foodRouter;
