
import '../../Utils/Services/CrudService.dart';
import 'Comment.dart';

class CommentService extends CrudService<Comment> {
  CommentService()
      : super(
    'comments',
    null,
    fromJson: (json) => Comment.fromJson(json),
    toJson: (data) => data.toJson(),
  );
}
