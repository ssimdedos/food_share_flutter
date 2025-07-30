import { Router } from 'express';
import { createFoodPost, getFoodPost, getFoods } from '../controllers/foodController';
import upload from '../config/multer';
import { authToken } from '../config/jwt';

const foodRouter: Router = Router();

// Matches with /api/foods
foodRouter.route('/')
  .get(authToken, getFoods)
  .post(authToken, upload.array('images', 5), createFoodPost);
foodRouter.route('/post/:id').get(authToken, getFoodPost);
export default foodRouter;
