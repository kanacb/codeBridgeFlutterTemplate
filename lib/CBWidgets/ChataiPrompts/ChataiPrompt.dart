import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../ChataiEnabler/ChataiEnabler.dart';
import '../ChataiConfig/ChataiConfig.dart';
 
 
part 'ChataiPrompt.g.dart';
 
@HiveType(typeId: 26)

class ChataiPrompt {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? session;
	@HiveField(2)
	 
	final ChataiEnabler? chatAiEnabler;
	@HiveField(3)
	 
	final ChataiConfig? chatAiConfig;
	@HiveField(4)
	 
	final String? prompt;
	@HiveField(5)
	 
	final String? refDocs;
	@HiveField(6)
	 
	final String? responseText;
	@HiveField(7)
	 
	final String? systemId;
	@HiveField(8)
	 
	final String? type;
	@HiveField(9)
	 
	final String? role;
	@HiveField(10)
	 
	final String? model;
	@HiveField(11)
	 
	final String? params;
	@HiveField(12)
	 
	final String? stopReason;
	@HiveField(13)
	 
	final String? stopSequence;
	@HiveField(14)
	 
	final int? inputTokens;
	@HiveField(15)
	 
	final int? outputTokens;
	@HiveField(16)
	 
	final int? cost;
	@HiveField(17)
	 
	final bool? status;
	@HiveField(18)
	 
	final String? error;
	@HiveField(19)
	 
	final String? userRemarks;
	@HiveField(20)
	 
	final bool? thumbsDown;
	@HiveField(21)
	 
	final bool? thumbsUp;
	@HiveField(22)
	 
	final bool? copies;
	@HiveField(23)
	 
	final bool? emailed;

  ChataiPrompt({
    this.id,
		this.session,
		this.chatAiEnabler,
		this.chatAiConfig,
		this.prompt,
		this.refDocs,
		this.responseText,
		this.systemId,
		this.type,
		this.role,
		this.model,
		this.params,
		this.stopReason,
		this.stopSequence,
		this.inputTokens,
		this.outputTokens,
		this.cost,
		this.status,
		this.error,
		this.userRemarks,
		this.thumbsDown,
		this.thumbsUp,
		this.copies,
		this.emailed
  });

  factory ChataiPrompt.fromJson(Map<String, dynamic> map) {
    return ChataiPrompt(
      id: map['_id'] as String?,
			session : map['session'] as String?,
			chatAiEnabler : map['chatAiEnabler'] != null ? ChataiEnabler.fromJson(map['chatAiEnabler']) : null,
			chatAiConfig : map['chatAiConfig'] != null ? ChataiConfig.fromJson(map['chatAiConfig']) : null,
			prompt : map['prompt'] as String?,
			refDocs : map['refDocs'] as String?,
			responseText : map['responseText'] as String?,
			systemId : map['systemId'] as String?,
			type : map['type'] as String?,
			role : map['role'] as String?,
			model : map['model'] as String?,
			params : map['params'] as String?,
			stopReason : map['stopReason'] as String?,
			stopSequence : map['stopSequence'] as String?,
			inputTokens : map['inputTokens'] as int,
			outputTokens : map['outputTokens'] as int,
			cost : map['cost'] as int,
			status : map['status'] as bool,
			error : map['error'] as String?,
			userRemarks : map['userRemarks'] as String?,
			thumbsDown : map['thumbsDown'] as bool,
			thumbsUp : map['thumbsUp'] as bool,
			copies : map['copies'] as bool,
			emailed : map['emailed'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"chatAiEnabler" : chatAiEnabler?.id.toString(),
			"chatAiConfig" : chatAiConfig?.id.toString(),
			"inputTokens" : inputTokens,
			"outputTokens" : outputTokens,
			"cost" : cost,
			"status" : status,
			"thumbsDown" : thumbsDown,
			"thumbsUp" : thumbsUp,
			"copies" : copies,
			"emailed" : emailed
    };
}

  @override
  String toString() => 'ChataiPrompt("_id" : $id,"session": $session.toString(),"chatAiEnabler": $chatAiEnabler.toString(),"chatAiConfig": $chatAiConfig.toString(),"prompt": $prompt.toString(),"refDocs": $refDocs.toString(),"responseText": $responseText.toString(),"systemId": $systemId.toString(),"type": $type.toString(),"role": $role.toString(),"model": $model.toString(),"params": $params.toString(),"stopReason": $stopReason.toString(),"stopSequence": $stopSequence.toString(),"inputTokens": $inputTokens,"outputTokens": $outputTokens,"cost": $cost,"status": $status,"error": $error.toString(),"userRemarks": $userRemarks.toString(),"thumbsDown": $thumbsDown,"thumbsUp": $thumbsUp,"copies": $copies,"emailed": $emailed)';
}