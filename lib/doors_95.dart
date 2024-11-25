import 'package:flutter/material.dart';

class TextButton95 extends TextButton{
  const TextButton95({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    super.statesController,
    super.isSemanticButton,
    super.iconAlignment,
    required super.child
  });
  @override
  State<ButtonStyleButton> createState() => TextButtonState95();
}

class TextButtonState95 extends State<TextButton95>{

  @override
  Widget build(BuildContext context) {
    // debugPrint('TextButton 95 Test');
    return Container(
      // color: Colors.grey,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        color: Colors.grey
      ),
      child: Container(
        decoration: ShapeDecoration(shape: Border(
            top: BorderSide(color: Colors.grey[100]!, width: 1.7),
            right: BorderSide(color: Colors.grey[600]!, width: 1.7),
            left: BorderSide(color: Colors.grey[100]!, width: 1.7),
            bottom: BorderSide(color: Colors.grey[600]!, width: 1.7)
        )),
        child: TextButton(
          onPressed: widget.onPressed,
          onLongPress: widget.onLongPress,
          onHover: widget.onHover,
          onFocusChange: widget.onFocusChange,
          style: null,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          clipBehavior: widget.clipBehavior,
          statesController: widget.statesController,
          isSemanticButton: widget.isSemanticButton,
          iconAlignment: widget.iconAlignment,
          child: widget.child!
        ),
        
      ),
    );
  }
}

class TextField95 extends TextField{
  final String? hintText;
  final BoxConstraints? constraints;
  const TextField95({
    this.hintText,
    this.constraints,
    super.key,
    super.controller,
    super.autocorrect,
    super.autofillHints,
    super.autofocus,
    super.buildCounter,
    super.canRequestFocus,
    super.clipBehavior,
    super.contentInsertionConfiguration,
    super.contextMenuBuilder,
    super.cursorErrorColor,
    super.cursorHeight,
    super.cursorOpacityAnimates,
    super.cursorRadius,
    super.cursorWidth,
    super.dragStartBehavior,
    super.enabled,
    super.enableIMEPersonalizedLearning,
    super.enableInteractiveSelection,
    super.enableSuggestions,
    super.expands,
    super.focusNode,
    super.groupId,
    super.ignorePointers,
    super.inputFormatters,
    super.keyboardAppearance,
    super.keyboardType,
    super.magnifierConfiguration,
    super.maxLength,
    super.maxLengthEnforcement,
    super.maxLines,
    super.minLines,
    super.mouseCursor,
    super.obscureText,
    super.obscuringCharacter,
    super.onAppPrivateCommand,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onTap,
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.readOnly,
    super.restorationId,
    super.scribbleEnabled,
    super.scrollController,
    super.scrollPadding,
    super.scrollPhysics,
    super.selectionControls,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.showCursor,
    super.smartDashesType,
    super.smartQuotesType,
    super.spellCheckConfiguration,
    super.statesController,
    super.strutStyle,
    super.style,
    super.textAlign,
    super.textAlignVertical,
    super.textCapitalization,
    super.textDirection,
    super.textInputAction,
    super.undoController
  });
  @override
  State<TextField> createState() => TextField95State();
}

class TextField95State extends State<TextField95>{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(shape: Border(
          top: const BorderSide(color: Colors.black, width: 2),
          right: BorderSide(color: Colors.grey[400]!, width: 2),
          left: const BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.grey[400]!, width: 2)
      ),
          color: Colors.white
      ),
      // padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 1),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          // filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          constraints: widget.constraints,
          // constraints: BoxConstraints.lerp(widget.constraints, BoxConstraints(maxHeight: 10), 1) ,
          isDense: true,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        ),// suffix icon maybe
        cursorColor: Colors.black,
          autocorrect: widget.autocorrect,
          autofillHints: widget.autofillHints,
          autofocus: widget.autofocus,
          buildCounter: widget.buildCounter,
          canRequestFocus: widget.canRequestFocus,
          clipBehavior: widget.clipBehavior,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          contextMenuBuilder: widget.contextMenuBuilder,
          cursorErrorColor: widget.cursorErrorColor,
          cursorHeight: widget.cursorHeight,
          cursorOpacityAnimates: widget.cursorOpacityAnimates,
          cursorRadius: widget.cursorRadius,
          cursorWidth: widget.cursorWidth,
          dragStartBehavior: widget.dragStartBehavior,
          enabled: widget.enabled,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          enableSuggestions: widget.enableSuggestions,
          expands: widget.expands,
          focusNode: widget.focusNode,
          groupId: widget.groupId,
          ignorePointers: widget.ignorePointers,
          inputFormatters: widget.inputFormatters,
          keyboardAppearance: widget.keyboardAppearance,
          keyboardType: widget.keyboardType,
          magnifierConfiguration: widget.magnifierConfiguration,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          mouseCursor: widget.mouseCursor,
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          onTapAlwaysCalled: widget.onTapAlwaysCalled,
          onTapOutside: widget.onTapOutside,
          readOnly: widget.readOnly,
          restorationId: widget.restorationId,
          scribbleEnabled: widget.scribbleEnabled,
          scrollController: widget.scrollController,
          scrollPadding: widget.scrollPadding,
          scrollPhysics: widget.scrollPhysics,
          selectionControls: widget.selectionControls,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          showCursor: widget.showCursor,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          spellCheckConfiguration: widget.spellCheckConfiguration,
          statesController: widget.statesController,
          strutStyle: widget.strutStyle,
          style: widget.style,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          textCapitalization: widget.textCapitalization,
          textDirection: widget.textDirection,
          textInputAction: widget.textInputAction,
          undoController: widget.undoController
      ),
    );
  }
}

class Container95 extends Container{
  final double? height;
  final double? width;
  Container95({
    super.key,
    super.child,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(shape: Border(
          top: const BorderSide(color: Colors.black, width: 2),
          right: BorderSide(color: Colors.grey[400]!, width: 2),
          left: const BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.grey[400]!, width: 2)
      ),
        color: Colors.grey
      ),
      width: width,
      height: height,
      child: child,
    );
  }

}