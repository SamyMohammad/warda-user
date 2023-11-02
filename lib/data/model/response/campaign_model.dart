/// banners : [{"id":4,"title":"new banner","description":"test desc edited","image":"https://warda.spiromo.store/public/storage/banner/2023-11-01-6542b90f92ced.png","button_text":"Click Here","category":{"id":3,"name":"Boquet"}}]

class CampaignModel {
  CampaignModel({
      this.banners,});

  CampaignModel.fromJson(dynamic json) {
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners?.add(Banners.fromJson(v));
      });
    }
  }
  List<Banners>? banners;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (banners != null) {
      map['banners'] = banners?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 4
/// title : "new banner"
/// description : "test desc edited"
/// image : "https://warda.spiromo.store/public/storage/banner/2023-11-01-6542b90f92ced.png"
/// button_text : "Click Here"
/// category : {"id":3,"name":"Boquet"}

class Banners {
  Banners({
      this.id, 
      this.title, 
      this.description, 
      this.image, 
      this.buttonText, 
      this.category,});

  Banners.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    buttonText = json['button_text'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? id;
  String? title;
  String? description;
  String? image;
  String? buttonText;
  Category? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['button_text'] = buttonText;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    return map;
  }

}

/// id : 3
/// name : "Boquet"

class Category {
  Category({
      this.id, 
      this.name,});

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}