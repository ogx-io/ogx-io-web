(function() {
  $.fn.colorfy.markdown = {
    "title": /^\s{0,3}\#{1,6}.*$/m,
    "block": /^\s{0,3}>\s+.*$/m,
    "orderedlist": /^\s*[0-9]+\. .+$/m,
    "unorderedlist": /^\s*[*+-] .+$/m,
    "strong": /([\*_]{2})[^\*_]+?\1/m,
    "emphasis": /([\*_])[^\*_]+?\1(?![\*_])/m,
    "strikethrough": /~~.+?~~/m,
    "codeblock": /```[a-z\s]*\n[\s\S]*?\n```/m,
    "inlinecode": /`[^`\n]+?`/,
    "rule": /^[-\*]{3,}/m
  };

}).call(this);
