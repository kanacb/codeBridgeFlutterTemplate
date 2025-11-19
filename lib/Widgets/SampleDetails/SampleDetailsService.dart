import '../../Utils/Services/CrudService.dart';


import 'SampleDetails.dart';

class SampleDetailsService extends CrudService<SampleDetails> {
  SampleDetailsService({String? query = ""})
      : super(
    'sampleDetails', // Endpoint for external tickets
    query,
    fromJson: (json) => SampleDetails.fromJson(json),
    toJson: (ticket) => ticket.toJson(),
  );
}
