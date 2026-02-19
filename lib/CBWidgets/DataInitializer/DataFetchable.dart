import 'package:aims/Utils/Services/CrudService.dart';

abstract class DataFetchable {
  Future<void> fetchAllAndSave();
}