const userController = require('../controller/user.controller');
const router = require('express').Router();
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });



router.post('/register', userController.register);
router.post('/login', userController.login);
router.post('/getUser', userController.getUser);
router.post('/updatePassword', userController.updatePassword);
router.post("/updateName", userController.updateName)
router.post("/updatePic", upload.single('profilePic'), userController.updatePic)
router.put('/updateUser', userController.updateUser);
 

module.exports = router;