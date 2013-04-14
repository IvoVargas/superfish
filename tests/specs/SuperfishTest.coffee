$ = jQuery

describe "Superfish", ->

  $menu = null

  beforeEach ->
    $menu = $('ul.sf-menu')
    $menu.superfish()
  
  afterEach ->
    $menu.superfish 'destroy'


  it "should exist", ->
    expect($.fn.superfish).toBeDefined()

  it "should be chainable", ->
    $menu.superfish 'destroy'
    expect($menu.superfish()).toBe 'ul'

  it "should store options", ->
    expect($menu.data 'sf-options' ).toBeDefined()


  describe "options", ->

    it "should have default options", ->
      options = $menu.data 'sf-options'
      expect(options.speed).toMatch 'normal'

    it "should allow default options to be overridden", ->
      $menu.superfish 'destroy'
      $menu.superfish
        speed: 1000
      options = $menu.data 'sf-options'
      expect(options.speed).toEqual 1000


  describe "method access", ->

    $liHasUl = null

    beforeEach ->
      $liHasUl = $menu.find('li:has(ul):first')

    it "'show' method should exist", ->
      expect($liHasUl.superfish('show')).toBeDefined()

    it "'hide' method should exist", ->
      expect($liHasUl.superfish('hide')).toBeDefined()

    it "'destroy' method should exist", ->
      expect($menu.superfish('destroy')).toBeDefined()
      $menu.superfish()

    it "should not allow access to private functions", ->
      expect( ->
        $menu.superfish('close')
      ).toThrow new Error('Method close does not exist on jQuery.fn.superfish')

    it "should not throw an error when accessing a valid method", ->
      expect( ->
        $liHasUl.superfish('show')
      ).not.toThrow new Error('Method show does not exist on jQuery.fn.superfish')


    describe "'destroy' method", ->

      it "should handle multiple calls gracefully", ->
        $menu.superfish('destroy')
        expect( ->
          $menu.superfish('destroy')
        ).not.toThrow new Error("Uncaught TypeError: Cannot read property 'sfTimer' of null")
        expect($menu.superfish('destroy')).toBe 'ul'


    describe "'show' method", ->
      it "should fail silently if Superfish is uninitialised", ->
        $menu.superfish('destroy')
        expect( $liHasUl.superfish('show') ).toBe 'li'

      it "should cause child ul to be visible", ->
        $submenu = $liHasUl.children('ul')
        expect($submenu).toBeHidden()
        expect($liHasUl).not.toBe '.sfHover'
        $liHasUl.superfish 'show'
        expect($submenu).toBeVisible()
        expect($liHasUl).toBe '.sfHover'


    describe "'hide' method", ->
      it "should fail silently if Superfish is uninitialised", ->
        $menu.superfish('destroy')
        expect( $liHasUl.superfish('hide') ).toBe 'li'
        
      it "should cause child ul to be hidden", ->
        $submenu = $liHasUl.children('ul')
        $liHasUl.superfish 'show'
        expect($liHasUl).toBe '.sfHover'
        expect($submenu).toBeVisible()
        # do an instant hide for now until I figure out why .toBeHidden fails when animated
        $liHasUl.superfish 'hide', true
        expect($submenu).toBeHidden()
        expect($liHasUl).not.toBe '.sfHover'
