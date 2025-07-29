import multer from "multer";
import path from "path";
import fs from "fs";

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const today = new Date();
    const year = today.getFullYear();
    const month = (today.getMonth() + 1).toString().padStart(2, '0'); // 월 (01~12)
    const day = today.getDate().toString().padStart(2, '0'); // 일 (01~31)

    // const datePath = path.join(year.toString(), month, day);
    const datePath = `${year.toString()}${month}${day}`;
    const userId = req.body.author || 'unknown'; // req.body에서 author를 가져오거나 'unknown'으로 설정

    const uploadDir = path.join('data', 'upload', datePath, `${userId}`);
    fs.mkdirSync(uploadDir, { recursive: true });
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname); // 원본 파일의 확장자 (.jpg, .png 등)
    const fileName = path.basename(file.originalname, ext); // 확장자를 제외한 파일명
    const uniqueSuffix = Math.round(Math.random() * 1E9); // 고유한 접미사
    cb(null, fileName + '_' + uniqueSuffix + ext); // 최종 파일명
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10000000 // 10MB로 파일 크기 제한 (선택 사항, 필요에 따라 조정)
  },
  fileFilter: function (req, file, cb) {
    // 허용할 파일 타입 (이미지만 허용)
    const filetypes = /jpeg|jpg|png|gif|webp/;
    const mimetype = filetypes.test(file.mimetype); // 파일 MIME 타입 검사
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase()); // 파일 확장자 검사

    if (mimetype && extname) {
      return cb(null, true); // 파일 허용
    } else {
      cb(new Error('Only images (jpeg, jpg, png, gif, webp) are allowed!')); // 파일 거부 및 에러 메시지
    }
  }
});

export default upload;
// export const uploadImgs = upload.array('images', 5);