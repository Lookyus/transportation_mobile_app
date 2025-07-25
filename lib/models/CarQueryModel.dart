class CarQueryModel{

  final String modelName;
  final String modelMakeId;

  const CarQueryModel({required this.modelName, required this.modelMakeId});

  factory CarQueryModel.fromJson(Map<String, dynamic> json){
    return CarQueryModel(
        modelName: json['model_name'] ?? '',
        modelMakeId: json['model_make_id'] ?? ''
    );
  }
}