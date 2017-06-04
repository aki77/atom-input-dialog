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
        labelText: 'enter word'
        elementClass: 'spec'
        labelClass: 'icon-file'
        defaultText: 'test.txt'
        selectedRange: [[0, 0], [0, 4]]

      inputDialog = new InputDialog(defaultOptions)

      miniEditor = inputDialog.miniEditor

      spyOn(inputDialog, "callback")

    it "label", ->
      {label} = inputDialog
      expect(label.textContent).toBe('enter word')

    it "elementClass", ->
      expect(inputDialog.element.classList.contains('spec')).toBeTruthy()

    it "callback", ->
      miniEditor.setText('test')
      atom.commands.dispatch(inputDialog.element, 'core:confirm')
      expect(inputDialog.callback).toHaveBeenCalledWith("test")

    it "iconClass", ->
      {label} = inputDialog
      expect(label.classList.contains('icon-file')).toBeTruthy()

    it "defaultText", ->
      expect(miniEditor.getText()).toBe('test.txt')

    it "selectedRange", ->
      expect(miniEditor.getSelectedText()).toBe('test')
      miniEditor.insertText('ab')
      expect(miniEditor.getText()).toBe('ab.txt')

    it "textPattern", ->
      inputDialog = new InputDialog(textPattern: /[0-7]/)
      miniEditor = inputDialog.miniEditor

      expect(miniEditor.getText()).toBe('')
      miniEditor.insertText('8')
      expect(miniEditor.getText()).toBe('')
      miniEditor.insertText('7')
      expect(miniEditor.getText()).toBe('7')
      miniEditor.insertText('0')
      expect(miniEditor.getText()).toBe('70')

    describe 'validator', ->
      it "required", ->
        miniEditor.setText('')
        atom.commands.dispatch(inputDialog.element, 'core:confirm')
        expect(inputDialog.callback).not.toHaveBeenCalled()
        expect(inputDialog.message.textContent).toEqual('required')

      it "not required", ->
        success = false

        inputDialog = new InputDialog(
          validator: ->
          callback: ->
            success = true
        )
        miniEditor = inputDialog.miniEditor

        miniEditor.setText('')
        expect(success).toBeFalsy()
        atom.commands.dispatch(inputDialog.element, 'core:confirm')
        expect(success).toBeTruthy()
        expect(inputDialog.message.textContent).toEqual('')

      it "custom", ->
        validator = (text) ->
          return 'invalid' unless text.match(/^[a-c]{3}$/)
          null

        inputDialog = new InputDialog({validator})
        miniEditor = inputDialog.miniEditor

        expect(inputDialog.message.textContent).toBe('')
        miniEditor.setText('abc')
        expect(inputDialog.message.textContent).toBe('')
        miniEditor.setText('abd')
        expect(inputDialog.message.textContent).toBe('invalid')
