/*
《代码文档》
naming 是一个方法，用于获取对象的名称。
*/
String naming(dynamic object) {
  if (object is String) {
    return object;
  }
  if (object is Type) {
    return (object).toString().replaceAll(RegExp(r"<.*>"), "");
  }
  return object.runtimeType.toString().replaceAll(RegExp(r"<.*>"), "");
}

/*
《代码文档》
typing 是一个方法，用于获取对象的类型。
*/
Object typing(dynamic object) {
  if (object is String) {
    return object;
  }
  if (object is Type) {
    return object;
  }
  return object.runtimeType;
}
