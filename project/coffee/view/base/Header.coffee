AbstractView         = require '../AbstractView'
Router               = require '../../router/Router'
CodeWordTransitioner = require '../../utils/CodeWordTransitioner'

class Header extends AbstractView

	template : 'site-header'

	FIRST_HASHCHANGE : true

	constructor : ->

		@templateVars =
			home    : 
				label    : @CD().locale.get('header_logo_label')
				url      : @CD().BASE_PATH + '/' + @CD().nav.sections.HOME
			about : 
				label    : @CD().locale.get('header_about_label')
				url      : @CD().BASE_PATH + '/' + @CD().nav.sections.ABOUT
			contribute : 
				label    : @CD().locale.get('header_contribute_label')
				url      : @CD().BASE_PATH + '/' + @CD().nav.sections.CONTRIBUTE
			close_label : @CD().locale.get('header_close_label')
			info_label : @CD().locale.get('header_info_label')

		super()

		@bindEvents()

		return null

	init : =>

		@$logo              = @$el.find('.logo__link')
		@$navLinkAbout      = @$el.find('.site-nav__link').eq(0)
		@$navLinkContribute = @$el.find('.site-nav__link').eq(1)
		@$infoBtn           = @$el.find('.info-btn')
		@$closeBtn          = @$el.find('.close-btn')

		null

	bindEvents : =>

		@CD().router.on Router.EVENT_HASH_CHANGED, @onHashChange

		@$el.on 'mouseenter', '[data-codeword]', @onWordEnter
		@$el.on 'mouseleave', '[data-codeword]', @onWordLeave

		null

	onHashChange : (where) =>

		if @FIRST_HASHCHANGE
			@FIRST_HASHCHANGE = false
			return
		
		@onAreaChange where

		null

	onAreaChange : (section) =>

		colour  = @getSectionColour section

		@$el.attr 'data-section', section

		CodeWordTransitioner.in @$logo, colour

		# this just for testing, tidy later
		if section is @CD().nav.sections.HOME
			CodeWordTransitioner.in @$navLinkAbout, colour
			CodeWordTransitioner.in @$navLinkContribute, colour
			CodeWordTransitioner.out @$closeBtn, colour
			CodeWordTransitioner.out @$infoBtn, colour
		else if section is @CD().nav.sections.DOODLES
			CodeWordTransitioner.out @$navLinkAbout, colour
			CodeWordTransitioner.out @$navLinkContribute, colour
			CodeWordTransitioner.in @$closeBtn, colour
			CodeWordTransitioner.in @$infoBtn, colour
		else
			CodeWordTransitioner.out @$navLinkAbout, colour
			CodeWordTransitioner.out @$navLinkContribute, colour
			CodeWordTransitioner.in @$closeBtn, colour
			CodeWordTransitioner.out @$infoBtn, colour

		null

	getSectionColour : (section) =>

		section = section or @CD().nav.current.area or 'home'

		colour  = switch section
			when 'home' then 'red'
			else 'blue'

		colour

	animateTextIn : =>

		@onAreaChange @CD().nav.current.area

		null

	onWordEnter : (e) =>

		$el = $(e.currentTarget)

		CodeWordTransitioner.scramble $el, @getSectionColour()

		null

	onWordLeave : (e) =>

		$el = $(e.currentTarget)

		CodeWordTransitioner.in $el, @getSectionColour()

		null

module.exports = Header
