//                    API Calls
final url = "http://localhost:3000/";
//                     API Calls

//                     User's API Calls
final userUrl = url + "user/";
final register = userUrl + "register";
final loginU = userUrl + "login";
final findUserU = userUrl + "getUser";
final updatePasswordU = userUrl + "updatePassword";
final updateUser = userUrl + "updateUser";
final updateProfilePic = userUrl + "updateProfilePic";
//                     User's API Calls


//                     Gig's API Calls
final gigUrl = url + "gig/";
final getGigs = gigUrl + "getAll";
final addGig = gigUrl + "add";
final updateGig = gigUrl + "edit/";
final getgigbyemail = gigUrl + "getallgigs/";
final deleteGig = gigUrl + "delete/";
//                     Gig's API Calls

//                     Job's API Calls
final jobUrl = url + "job/";
final getJobs = jobUrl + "getAll";
final addJob = jobUrl + "add";
final updateJob = jobUrl + "edit/";
final getjobbyemail = jobUrl + "getalljobs/";
final deleteJob = jobUrl + "delete/";
//                     Job's API Calls

//                     category's API Calls
final categoryUrl = url + "category/";
final getCategories = categoryUrl + "getAll";
//                     category's API Calls
