class Menu {
  int id;
  String menuName;
  String alias;
  String groups;
  int displayOrder;
  bool isActive;

  Menu({
    this.id,
    this.menuName,
    this.alias,
    this.groups,
    this.displayOrder,
    this.isActive
  });

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "menu_name": menuName,
      "alias": alias,
      "groups": groups,
      "display_order": displayOrder,
      "is_active":(isActive)? 1 : 0
    };
  }
}