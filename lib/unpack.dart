String unpack(String msg){
  int start = msg.indexOf('<');
  int stop = msg.indexOf('>')+1;
  if(start < 0 || stop < 0){
    return '';
  }
  String type = msg.substring(start,stop);
  String typeEnd = type.replaceFirst('<', '</');
  return msg.substring(msg.indexOf(type)+type.length,msg.indexOf(typeEnd));
}