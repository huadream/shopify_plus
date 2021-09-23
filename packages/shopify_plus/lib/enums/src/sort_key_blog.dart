enum SortKeyBlog {
  HANDLE,
  TITLE,
  ID,
  RELEVANCE
}

extension ParseToStringBlog on SortKeyBlog{
  String parseToString(){
    return this.toString().split('.')[1];
  }
}