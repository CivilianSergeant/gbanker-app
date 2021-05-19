class MenuPermission{
  int id;
  String roleId;
  String alias;
  bool isActive;
  bool view;
  bool create;
  bool delete;
  bool approve;
  bool disburse;

  MenuPermission({
    this.id,
    this.roleId,
    this.alias,
    this.isActive,
    this.view,
    this.create,
    this.delete,
    this.approve,
    this.disburse
  });

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "role_id": roleId,
      "alias": alias,
      "is_active": (isActive)? 1 : 0,
      "view_permission": (view)? 1 : 0,
      "create_permission": (create)? 1 : 0,
      "delete_permission": (delete)? 1 : 0,
      "approve_permission": (approve)? 1 : 0,
      "disburse_permission": (disburse)? 1 : 0
    };
  }
}