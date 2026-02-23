import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../ChataiEnabler/ChataiEnabler.dart';
 
 
part 'ChataiConfig.g.dart';
 
@HiveType(typeId: 25)

class ChataiConfig {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;
	@HiveField(2)
	 
	final ChataiEnabler chatAiEnabler;
	@HiveField(3)
	 
	final String? bedrockModelId;
	@HiveField(4)
	 
	final String? modelParamsJson;
	@HiveField(5)
	 
	final String? human;
	@HiveField(6)
	 
	final String? task;
	@HiveField(7)
	 
	final String? noCondition;
	@HiveField(8)
	 
	final String? yesCondition;
	@HiveField(9)
	 
	final String? documents;
	@HiveField(10)
	 
	final String? example;
	@HiveField(11)
	 
	final String? preamble;

  ChataiConfig({
    this.id,
		this.name,
		required this.chatAiEnabler,
		this.bedrockModelId,
		this.modelParamsJson,
		this.human,
		this.task,
		this.noCondition,
		this.yesCondition,
		this.documents,
		this.example,
		this.preamble
  });

  factory ChataiConfig.fromJson(Map<String, dynamic> map) {
    return ChataiConfig(
      id: map['_id'] as String?,
			name : map['name'] as String?,
			chatAiEnabler : ChataiEnabler.fromJson(map['chatAiEnabler']),
			bedrockModelId : map['bedrockModelId'] as String?,
			modelParamsJson : map['modelParamsJson'] as String?,
			human : map['human'] as String?,
			task : map['task'] as String?,
			noCondition : map['noCondition'] as String?,
			yesCondition : map['yesCondition'] as String?,
			documents : map['documents'] as String?,
			example : map['example'] as String?,
			preamble : map['preamble'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"chatAiEnabler" : chatAiEnabler.id.toString()
    };
}

  @override
  String toString() => 'ChataiConfig("_id" : $id,"name": $name.toString(),"chatAiEnabler": $chatAiEnabler.toString(),"bedrockModelId": $bedrockModelId.toString(),"modelParamsJson": $modelParamsJson.toString(),"human": $human.toString(),"task": $task.toString(),"noCondition": $noCondition.toString(),"yesCondition": $yesCondition.toString(),"documents": $documents.toString(),"example": $example.toString(),"preamble": $preamble.toString())';
}