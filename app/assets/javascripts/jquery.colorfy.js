(function() {
  var colorfy, commonAncestorOfTwoNodes, createNode, cursorLocationForRootNodeFromAnchorNodeAndOffset, dataTextToFormattedText, formattedTextToDataText, htmlfy, isChrome, isFirefox, isOldIE, lengthOfNode, lengthOfNodeToOffset, nodeAndOffsetFromCursorLocation, objectToAssociativeArray, parentsOfNode, restoreCursorLocation, saveCursorLocation, shouldUpdate;

  shouldUpdate = false;

  isOldIE = function() {
    var ua;
    ua = window.navigator.userAgent;
    if (ua.indexOf("MSIE ") > 0) {
      return true;
    } else {
      return false;
    }
  };

  isChrome = function() {
    var ua;
    ua = window.navigator.userAgent;
    if (ua.indexOf("Chrome") > 0) {
      return true;
    } else {
      return false;
    }
  };

  isFirefox = function() {
    var ua;
    ua = window.navigator.userAgent;
    if (ua.indexOf("Firefox") > 0) {
      return true;
    } else {
      return false;
    }
  };

  objectToAssociativeArray = function(obj) {
    var assObj, key, retArr, value;
    if (Array.isArray(obj)) {
      return obj;
    }
    retArr = [];
    for (key in obj) {
      value = obj[key];
      assObj = {};
      assObj[key] = value;
      retArr.unshift(assObj);
    }
    return retArr;
  };

  createNode = function(content, htmlfier, descriptor, klass) {
    var node;
    node = {};
    node.content = content;
    node.htmlfier = htmlfier;
    node.descriptor = objectToAssociativeArray(descriptor);
    node.klass = klass;
    node.subnodes = [];
    node.supernode = null;
    node.processed = false;
    node.terminate = false;
    node.toHTML = function() {
      var closeSpan, j, len, openSpan, ref;
      if (!node.processed) {
        node.process();
      }
      openSpan = this.klass ? "<span class='" + this.klass + "'>" : '';
      content = '';
      if (this.terminate) {
        content += this.htmlfier(this.content);
      } else {
        ref = this.subnodes;
        for (j = 0, len = ref.length; j < len; j++) {
          node = ref[j];
          content += node.toHTML();
        }
      }
      closeSpan = this.klass ? "</span>" : '';
      return openSpan + content + closeSpan;
    };
    node.process = function() {
      var currentIndex, hasMatchData, matchData, matched, matchedNewNode, newNode, regexp, remainder, rule, unmatched, unmatchedNewNode;
      if (this.descriptor.length === 0) {
        this.terminate = true;
      } else {
        rule = this.descriptor.pop();
        for (klass in rule) {
          regexp = rule[klass];
          currentIndex = 0;
          remainder = this.content;
          while (matchData = regexp.exec(remainder)) {
            hasMatchData = true;
            unmatched = remainder.substr(currentIndex, matchData.index);
            matched = matchData[0];
            currentIndex = matched.length + matchData.index;
            remainder = remainder.substr(currentIndex);
            currentIndex = 0;
            if (unmatched.length > 0) {
              unmatchedNewNode = createNode(unmatched, this.htmlfier, this.descriptor.slice(0), null);
              this.subnodes.push(unmatchedNewNode);
            }
            matchedNewNode = createNode(matched, this.htmlfier, this.descriptor.slice(0), klass);
            this.subnodes.push(matchedNewNode);
          }
          newNode = createNode(remainder, this.htmlfier, this.descriptor.slice(0), null);
          this.subnodes.push(newNode);
        }
      }
      return node.processed = true;
    };
    return node;
  };

  htmlfy = function(dataText) {
    dataText = dataText.replace(/&/g, '&amp;');
    dataText = dataText.replace(/</g, '&lt;');
    dataText = dataText.replace(/>/g, '&gt;');
    dataText = dataText.replace(/"/g, '&quot;');
    dataText = dataText.replace(/'/g, '&apos;');
    dataText = dataText.replace(/\//g, '&#x2F;');
    dataText = dataText.replace(/\n/g, '<br>');
    dataText = dataText.replace(new RegExp(' ', 'g'), '&nbsp;');
    return dataText;
  };

  colorfy = function(dataText, descriptor, htmlfier, descriptorName) {
    var node;
    htmlfier || (htmlfier = htmlfy);
    node = createNode(dataText, htmlfier, descriptor, descriptorName);
    return node.toHTML();
  };

  dataTextToFormattedText = function(dataText, syntaxDescriptor) {
    return colorfy(dataText, $.fn.colorfy[syntaxDescriptor], htmlfy, syntaxDescriptor);
  };

  formattedTextToDataText = function(formattedText) {
    formattedText = formattedText.replace(/<(?!br|\/br).+?>/gm, '');
    formattedText = formattedText.replace(/<br>/g, '\n');
    formattedText = formattedText.replace(/&lt;/g, '<');
    formattedText = formattedText.replace(/&gt;/g, '>');
    formattedText = formattedText.replace(/&amp;/g, '&');
    formattedText = formattedText.replace(/&quot;/g, '"');
    formattedText = formattedText.replace(/&apos;/g, "'");
    formattedText = formattedText.replace(/&#x2F/g, "/");
    formattedText = formattedText.replace(/&nbsp;/g, ' ');
    return formattedText;
  };

  parentsOfNode = function(node) {
    var nodes;
    nodes = [node];
    while (node = node.parentNode) {
      nodes.unshift(node);
    }
    return nodes;
  };

  commonAncestorOfTwoNodes = function(node1, node2) {
    var i, j, parents1, parents2, ref;
    parents1 = parentsOfNode(node1);
    parents2 = parentsOfNode(node2);
    if (parents1[0] !== parents2[0]) {
      return null;
    }
    for (i = j = 0, ref = parents1.length; j < ref; i = j += 1) {
      if (parents1[i] !== parents2[i]) {
        return parents1[i - 1];
      }
    }
  };

  cursorLocationForRootNodeFromAnchorNodeAndOffset = function(rootNode, anchorNode, anchorOffset, currentNode) {
    var childNode, j, len, location, ref;
    if (!currentNode) {
      currentNode = rootNode;
    }
    if (currentNode === anchorNode) {
      return lengthOfNodeToOffset(anchorNode, anchorOffset);
    } else if (!currentNode.contains(anchorNode) && rootNode.contains(commonAncestorOfTwoNodes(currentNode, anchorNode)) && (currentNode.compareDocumentPosition(anchorNode) === Node.DOCUMENT_POSITION_FOLLOWING)) {
      return lengthOfNode(currentNode);
    } else if (!currentNode.contains(anchorNode) && rootNode.contains(commonAncestorOfTwoNodes(currentNode, anchorNode)) && (currentNode.compareDocumentPosition(anchorNode) === Node.DOCUMENT_POSITION_PRECEDING)) {
      return 0;
    } else if (currentNode.contains(anchorNode)) {
      location = 0;
      ref = currentNode.childNodes;
      for (j = 0, len = ref.length; j < len; j++) {
        childNode = ref[j];
        location += cursorLocationForRootNodeFromAnchorNodeAndOffset(rootNode, anchorNode, anchorOffset, childNode);
      }
      return location;
    }
  };

  lengthOfNode = function(node) {
    var childNode, j, len, length, ref;
    if (node.nodeType === Node.TEXT_NODE) {
      return node.nodeValue.length;
    } else if (node.tagName === "BR") {
      return 1;
    } else if ((node.tagName === "SPAN") || (node.tagName === "DIV")) {
      length = 0;
      ref = node.childNodes;
      for (j = 0, len = ref.length; j < len; j++) {
        childNode = ref[j];
        length += lengthOfNode(childNode);
      }
      return length;
    }
  };

  lengthOfNodeToOffset = function(node, offset) {
    var i, j, length, ref;
    if (node.nodeType === Node.TEXT_NODE) {
      return offset;
    } else if (node.tagName === "BR") {
      console.log("Is this correct behavior?");
      return offset;
    } else if ((node.tagName === "SPAN") || (node.tagName === "DIV")) {
      length = 0;
      for (i = j = 0, ref = offset; j < ref; i = j += 1) {
        length += lengthOfNode(node.childNodes[i]);
      }
      return length;
    }
  };

  nodeAndOffsetFromCursorLocation = function(location, node) {
    var childNode, j, len, ref;
    if (lengthOfNode(node) < location) {
      return [];
    }
    if (node.nodeType === Node.TEXT_NODE) {
      return [node, location];
    } else if (node.tagName === "BR") {
      if (isChrome()) {
        return [node.nextSibling, 0];
      } else if (isFirefox()) {
        if (node.nextSibling.tagName === "BR") {
          return [node.nextSibling, 0];
        } else {
          return [node, 0];
        }
      } else {
        return [node, location];
      }
    } else {
      ref = node.childNodes;
      for (j = 0, len = ref.length; j < len; j++) {
        childNode = ref[j];
        if (lengthOfNode(childNode) < location) {
          location -= lengthOfNode(childNode);
        } else {
          return nodeAndOffsetFromCursorLocation(location, childNode);
        }
      }
    }
  };

  saveCursorLocation = function(jObject) {
    var anchorNode, anchorOffset, cursorLo, plainObject, sel;
    plainObject = jObject[0];
    if (document.activeElement !== plainObject) {
      return;
    }
    sel = window.getSelection();
    if (!sel.isCollapsed) {
      return;
    }
    anchorNode = sel.anchorNode;
    anchorOffset = sel.anchorOffset;
    if (!plainObject.contains(anchorNode)) {
      return;
    }
    cursorLo = cursorLocationForRootNodeFromAnchorNodeAndOffset(plainObject, anchorNode, anchorOffset);
    return jObject.data("cursorlocation", cursorLo);
  };

  restoreCursorLocation = function(jObject) {
    var anchorNode, anchorOffset, plainObject, ref, sel;
    plainObject = jObject[0];
    if (document.activeElement !== plainObject) {
      return;
    }
    sel = window.getSelection();
    if (!sel.isCollapsed) {
      return;
    }
    ref = nodeAndOffsetFromCursorLocation(jObject.data("cursorlocation"), plainObject), anchorNode = ref[0], anchorOffset = ref[1];
    if (anchorNode && anchorOffset >= 0) {
      return sel.collapse(anchorNode, anchorOffset);
    }
  };

  $.fn.colorfy = function(syntaxDescriptor) {
    if (isOldIE()) {
      return;
    }
    return this.each(function() {
      var $this, area, div;
      $this = $(this);
      div = $("<div></div>");
      div.attr("contenteditable", "true");
      div.attr("class", $this.attr("class"));
      div.css("max-height", $this.height());
      div.css("height", $this.height());
      if ($this.prop("tagName") === "input") {
        div.css("overflow", "hidden");
      } else {
        div.css("overflow", "scroll");
      }
      $this.after(div);
      $this.css("display", "none");
      area = $this;
      area.on("keyup paste", function(e) {
        return div.data("content", area.val()).trigger("receive-content");
      });
      div.on("receive-content", function(e) {
        if (div.text().length === 0) {
          div.css("display", "block");
        } else {
          div.css("display", "inline-block");
        }
        div.html(dataTextToFormattedText(div.data("content"), syntaxDescriptor));
        restoreCursorLocation(div);
      });
      div.on("send-content", function(e) {
        if (div.text().length === 0) {
          div.css("display", "block");
        } else {
          div.css("display", "inline-block");
        }
        return area.val(div.data("content"));
      });
      div.on("keypress", function(e) {
        shouldUpdate = true;
      });
      div.on("input paste", function(e) {
        if (shouldUpdate) {
          saveCursorLocation(div);
          div.data("content", formattedTextToDataText(div.html())).trigger("send-content").trigger("receive-content");
        }
        shouldUpdate = false;
      });
      return div.data("content", $this.val()).trigger("receive-content");
    });
  };

}).call(this);
