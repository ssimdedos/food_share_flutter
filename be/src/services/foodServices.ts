import Food from "../models/Food";

export const getAllFoods = async ():Promise<Food[] | null> => {
  return await Food.findAll({ attributes: ['id', 'title', 'thumbnailUrl', 'createdAt'], order: [['createdAt', 'ASC']]});
}

export const _createFoodPost = async (
  postData: {
    author: string; 
    title: string; 
    description: string; 
    imageUrl: string; 
    thumbnailUrl: string;
    expirationDate: Date }):Promise<Food | null> => {
  await Food.create(postData);

  return await Food.findOne({ attributes: ['id'], where: {title: postData.title} });
}

export const _getFoodPost = async (postId: number): Promise<Food | null> => {
  return await Food.findOne({ where: {id: postId} });
}