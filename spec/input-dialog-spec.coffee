{$, $$}  = require 'atom-space-pen-views'
InputDialog = require '../src/input-dialog'

describe 'inputDialog', ->
  [inputDialog, miniEditor, defaultOptions] = []

  beforeEach ->

  describe "initialize", ->
    beforeEach ->
      workspaceElement = atom.views.getView(atom.workspace)
      jasmine.attachToDOM(workspaceElement)

      defaultOptions =
        callback: ->
        prompt: 'enter word'
        elementClass: 'spec'
        iconClass: 'icon-file'
        defaultText: 'test.txt'
        selectedRange: [[0, 0], [0, 4]]

      inputDialog = new InputDialog(defaultOptions)

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

    it "match", ->
      inputDialog = new InputDialog(match: /[0-7]/)
      miniEditor = inputDialog.miniEditor.getModel()

      expect(miniEditor.getText()).toBe('')
      miniEditor.insertText('8')
      expect(miniEditor.getText()).toBe('')
      miniEditor.insertText('7')
      expect(miniEditor.getText()).toBe('7')
      miniEditor.insertText('0')
      expect(miniEditor.getText()).toBe('70')

    it "validate", ->
      validate = (text) ->
        return 'invalid' unless text.match(/^[a-c]{3}$/)
        null

      inputDialog = new InputDialog({validate})
      miniEditor = inputDialog.miniEditor.getModel()

      expect(inputDialog.errorMessage.text()).toBe('')
      miniEditor.setText('abc')
      expect(inputDialog.errorMessage.text()).toBe('')
      miniEditor.setText('abd')
      expect(inputDialog.errorMessage.text()).toBe('invalid')

    describe 'detached', ->
      [ok] = []
      detached = ->
        ok = true

      beforeEach ->
        ok = false

      it 'not called with detached',  ->
        inputDialog = new InputDialog()
        inputDialog.attach()
        inputDialog.close()
        expect(ok).toBeFalsy()

      it 'called with detached',  ->
        inputDialog = new InputDialog({detached})
        inputDialog.attach()
        inputDialog.close()
        expect(ok).toBeTruthy()
