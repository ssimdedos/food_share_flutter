import { NextFunction, Request, Response } from "express";
import { _createFoodPost, _getFoodPost, getAllFoods } from "../services/foodServices";

export const getFoods = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const foods = await getAllFoods();
    res.status(200).json(foods);
  } catch (error) {
    next(error);
  }
}

export const createFoodPost = async (req: Request, res: Response, next: NextFunction) => {
  const { title, author,description, expirationDate } = req.body;
  let imageUrls = [];
  let thumbnailUrl = '';
  const fileArray =  req.files ? req.files as Express.Multer.File[] : [];
  if (!fileArray || fileArray.length === 0) {
    return res.status(400).json({ success: false, message: 'No files uploaded or file type not allowed.' });
  } else {
    for (let i = 0; i < fileArray.length; i++) {
      const url = `${process.env.SERVER_URL}/images/${fileArray[i].path.split('upload\\')[1].replace(/\\/g, '/')}`;
      imageUrls.push(url);
    }
    thumbnailUrl = imageUrls[0] ? imageUrls[0] : `${process.env.SERVER_URL}/images/content_img.jpg`;
    console.log(imageUrls.toString());
    const postData = {
      title,
      author,
      description,
      expirationDate,
      'imageUrl':imageUrls.toString(),
      thumbnailUrl,
    }
    try {
      const createRes = await _createFoodPost(postData);
      res.status(201).json(createRes);
    } catch (error) {
      res.status(400).json(`게시글 등록 실패, ${error}`);
      next(error);
    }
  }
}

export const getFoodPost = async (req: Request, res: Response, next: NextFunction) => {
  const { id } = req.params;
  console.log(req.params.id);
  try {
    const getRes = await _getFoodPost(parseInt(id, 10));
    res.status(200).json(getRes);
  } catch (e) {
    res.status(400).json(`게시글 불러오기 실패, ${e}`);
    next(e);
  }
}