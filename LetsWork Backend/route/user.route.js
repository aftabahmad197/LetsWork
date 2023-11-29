const userController = require('../controller/user.controller');
const router = require('express').Router();



router.post('/register', userController.register);
router.post('/login', userController.login);
router.post('/getUser', userController.getUser);
router.post('/updatePassword', userController.updatePassword);
router.post("/updateName", userController.updateName)
router.put('/updateUser', userController.updateUser);
router.post('/updateProfilePic', userController.updateProfilePic);
 

module.exports = router;