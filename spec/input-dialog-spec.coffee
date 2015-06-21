{$, $$}  = require 'atom-space-pen-views'
InputDialog = require '../src/input-dialog'

describe "SelectListView", ->
  [inputDialog, miniEditor] = []

  beforeEach ->

  describe "initialize", ->
    beforeEach ->
      inputDialog = new InputDialog
        callback: ->
        prompt: 'enter word'
        elementClass: 'spec'
        iconClass: 'icon-file'
        defaultText: 'test.txt'
        selectedRange: [[0, 0], [0, 4]]
      miniEditor = inputDialog.miniEditor.getModel()

      spyOn(inputDialog, "callback")

    it "prompt", ->
      {promptText} = inputDialog
      expect(promptText.html()).toBe('enter word')

    it "elementClass", ->
      expect(inputDialog.element.classList.contains('spec')).toBeTruthy()

    it "callback", ->
      miniEditor.setText('test')
      atom.commands.dispatch(inputDialog.element, 'core:confirm')
      expect(inputDialog.callback).toHaveBeenCalledWith("test")

    it "iconClass", ->
      {promptText} = inputDialog
      expect(promptText.hasClass('icon-file')).toBeTruthy()

    it "defaultText", ->
      expect(miniEditor.getText()).toBe('test.txt')

    it "selectedRange", ->
      expect(miniEditor.getSelectedText()).toBe('test')
      miniEditor.insertText('ab')
      expect(miniEditor.getText()).toBe('ab.txt')
