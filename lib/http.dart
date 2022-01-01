import 'dart:convert';
import 'package:http/http.dart' as http;



List<Post> userPostFromJson(String str) {
  final jsonData = json.decode(str);
  print(jsonData['data']);

  return List<Post>.from(jsonData['data'].map((x) => Post.fromJson(x)));
}
List<Comment> userCommentFromJson(String str) {
  final jsonData = json.decode(str);
  print(jsonData['data']);

  return List<Comment>.from(jsonData['data'].map((x) => Comment.fromJson(x)));
}

List<User> parseUser(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

List<Post> parsePost(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}
class User {
  int? id;
  String? name;
  String? email;
  String? gender;
  String? status;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.gender,
      required this.status
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "gender": gender,
    "status" :status
  };



}



class Post {
  int? id;
  int? userId;
  String? title;
  String? body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] ,
      userId: json["userId"] ,
      title: json["title"] ,
      body: json["body"] ,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "body": body,
      };
}

class Comment {
  int? id;
  int? postId;
  String? name;
  String? email;
  String? body;

  Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      postId: json["postId"],
      name: json["name"],
      email: json["email"],
      body: json["body"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "postId": postId,
    "name": name,
    "email": email,
    "body": body,
  };
}

class GetRepo {
  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse('https://gorest.co.in/public/v1/users'));
       List<User> users = parseUser(response.body);
      return users;
  }

  Future<List<Post>> getAllPost() async {
    final response = await http.get(Uri.parse('https://gorest.co.in/public/v1/posts'));
    List<Post> post = parsePost(response.body);
    return post;
  }

  Future<List<Post>> getPost(userId) async {
    final response = await http.get(Uri.parse('https://gorest.co.in/public/v1/users/$userId/posts'));
    print(response.body);
    return userPostFromJson(response.body);
  }
  Future<List<Comment>> getComment(userId) async {
    final response = await http.get(Uri.parse('https://gorest.co.in/public/v1/posts/$userId/comments'));
    print(response.body);
    return userCommentFromJson(response.body);
  }

}

void main() async{
  GetRepo call = GetRepo();
   List<User> listofUsers = await call.getAllUsers();

   for(var user in listofUsers){

    // call post for each user
    await Future.delayed(Duration(seconds: 1));

    print("calling get POST call for user:"+user.id.toString());
    call.getPost(user.id);
  }
  List<Post> listofPost = await call.getAllPost();

  for(var post in listofPost){

    // call post for each comment
    await Future.delayed(Duration(seconds: 1));

    print("calling get Comment call for post :"+post.id.toString());
    call.getComment(post.id);
  }


}
