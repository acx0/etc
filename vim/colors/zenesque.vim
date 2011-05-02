" =============================================================================
" File:        zenesque.vim
" Description: Vim color scheme file
" Maintainer:  Paul Sampi;
" =============================================================================
set background=light
highlight clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "zenesque"
" =============================================================================
hi ColorColumn  guifg=NONE              guibg=#e6e6e6
hi Cursor       guifg=bg                guibg=fg                gui=NONE
hi CursorIM     guifg=bg                guibg=fg                gui=NONE
hi lCursor      guifg=bg                guibg=fg                gui=NONE
hi DiffAdd      guifg=NONE              guibg=#9d9d9d           gui=NONE
hi DiffChange   guifg=NONE              guibg=#d1d1d1           gui=NONE
hi DiffDelete   guifg=NONE              guibg=#d8d8d5           gui=NONE
hi DiffText     guifg=black             guibg=#bababa           gui=NONE
hi Directory    guifg=#525252           guibg=bg                gui=NONE
hi ErrorMsg     guifg=#6f6f6f           guibg=NONE              gui=NONE
hi FoldColumn   guifg=#555555           guibg=#cccbcb           gui=bold
hi Folded       guifg=#555555           guibg=#acacac           gui=italic

hi IncSearch    guifg=black             guibg=#adadad          gui=NONE
hi Search       guifg=black             guibg=#adadad          gui=NONE
hi MatchParen   guifg=black             guibg=#cccccc          gui=bold
hi ModeMsg      guifg=White             guibg=#767676          gui=bold
hi MoreMsg      guifg=#7c7c7c           guibg=bg               gui=bold
hi NonText      guifg=#7e7e7e           guibg=bg               gui=bold

hi Pmenu        guifg=#646564           guibg=#b1b2b1          gui=reverse
hi PmenuSbar    guifg=White             guibg=#989898          gui=NONE
hi PmenuThumb   guifg=White             guibg=#777777          gui=NONE

hi Question     guifg=#454545           guibg=bg               gui=bold
hi SignColumn   guifg=white             guibg=#c5c5c5          gui=NONE

hi SpecialKey   guifg=white             guibg=ivory3           gui=NONE

hi SpellBad     guisp=#323232           guibg=#d1cdcd          gui=undercurl
hi SpellCap     guisp=#5d5d5d                                  gui=undercurl
hi SpellLocal   guisp=#434343                                  gui=undercurl
hi SpellRare    guisp=#7d7d7d                                  gui=undercurl
hi StatusLine   guifg=#e8e8e8           guibg=#858585          gui=bold
hi StatusLineNC guifg=#808080           guibg=#bbbbbb          gui=italic
hi TabLine      guifg=fg                guibg=LightGrey        gui=underline
hi TabLineFill  guifg=fg                guibg=bg               gui=reverse
hi TabLineSel   guifg=fg                guibg=bg               gui=bold
hi Title        guifg=#6d6d6d           guibg=bg               gui=NONE
hi VertSplit    guifg=#b9b9b9           guibg=#b9b9b9
hi Visual       guifg=white             guibg=#9a9a9a          gui=NONE
hi WarningMsg   guifg=#cfcfcf           guibg=#5b5b5b          gui=NONE
hi WildMenu     guifg=Black             guibg=#c2c2c2          gui=NONE

" -----------------------------------------------------------------------------

if exists('g:zenesque_colors') && g:zenesque_colors==1

    hi CursorLine   guifg=NONE             guibg=#d4d4c0   gui=NONE
    hi Normal       guifg=#000000          guibg=#dbdbd2   gui=NONE
    hi LineNr       guifg=#888875          guibg=NONE      gui=NONE
    hi Constant     guifg=#73221A          guibg=NONE      gui=NONE
    hi String       guifg=#2c4c3b          guibg=NONE      gui=NONE
    hi Function     guifg=#084166          guibg=NONE      gui=NONE
    hi Statement    guifg=#412252          guibg=NONE      gui=NONE
    hi Conditional  guifg=#54240b          guibg=NONE      gui=NONE
    hi Type         guifg=#202969          guibg=NONE      gui=italic
    hi Todo         guifg=#6c0303          guibg=NONE      gui=bold
    hi PmenuSel     guifg=fg               guibg=#c37a23   gui=bold

else
    hi CursorLine   guifg=NONE             guibg=#e1e1d0   gui=NONE
    hi Normal       guifg=#000000          guibg=#e9e9dd   gui=NONE
    hi LineNr       guifg=#a9a99e          guibg=NONE      gui=NONE
    hi Constant     guifg=#353535          guibg=NONE      gui=bold
    hi Statement    guifg=black            guibg=NONE      gui=NONE
    hi Function     guifg=fg               guibg=NONE      gui=bold
    hi String       guifg=#3c3c3c          guibg=NONE      gui=NONE
    hi Type         guifg=#616161          guibg=NONE      gui=bold,italic
    hi Conditional  guifg=#4d4d4d          guibg=NONE      gui=bold
    hi Todo         guifg=bg               guibg=#898989   gui=bold
    hi PmenuSel     guifg=#a9a9aa          guibg=#f2f2f2   gui=bold,reverse
endif
hi Comment      guifg=#797979          guibg=NONE      gui=italic
hi Boolean      guifg=#616060          guibg=NONE      gui=bold
hi Identifier   guifg=#141414          guibg=NONE      gui=bold
hi Keyword      guifg=#666666          guibg=NONE      gui=underline
hi PreProc      guifg=#6b6b6b          guibg=NONE      gui=NONE
hi Special      guifg=#6e6e6e          guibg=NONE      gui=NONE
hi Ignore       guifg=bg               guibg=NONE      gui=NONE
hi Error        guifg=#727272          guibg=NONE      gui=undercurl
" -----------------------------------------------------------------------------
hi VimError         guifg=#b6b6b6      guibg=#313131   gui=bold
hi VimCommentTitle  guifg=#5c5c5c      guibg=bg        gui=bold,italic
hi qfFileName       guifg=#dedede      guibg=NONE      gui=italic
hi qfLineNr         guifg=#b4b4b4      guibg=NONE      gui=bold
hi qfError          guifg=#8e8e8e      guibg=NONE      gui=bold

" -----------------------------------------------------------------------------
hi pythonDecorator  guifg=#3b3b3b      guibg=NONE      gui=bold
hi link pythonDecoratorFunction pythonDecorator
" -----------------------------------------------------------------------------
hi diffOldFile          guifg=#717171           guibg=NONE      gui=NONE
hi diffNewFile          guifg=#ababab           guibg=NONE      gui=bold
hi diffFile             guifg=#676767           guibg=NONE      gui=NONE
hi link diffOnly        Constant
hi link diffIdentical   Constant
hi link diffDiffer      Constant
hi link diffBDiffer     Constant
hi link diffIsA         Constant
hi link diffNoEOL       Constant
hi link diffCommon      Constant
hi diffRemoved          guifg=#b1b1b1           guibg=NONE      gui=NONE
hi diffChanged          guifg=#727272           guibg=NONE      gui=NONE
hi diffAdded            guifg=#919191           guibg=NONE      gui=NONE
hi diffLine             guifg=#4e4e4e           guibg=NONE      gui=italic
hi link diffSubname     diffLine
hi link diffComment     Comment
" -----------------------------------------------------------------------------
hi htmlLink             guifg=#666666          guibg=NONE      gui=underline,italic
hi htmlTagName          guifg=NONE             guibg=NONE      gui=NONE
hi link htmlScriptTag htmlTagName
hi link htmlTagN htmlTagName
hi link htmlEndTag htmlTagName
hi link htmlSpecialTagName htmlTagName

hi link cssRenderAttr Constant 
hi link cssTextAttr Constant
hi link cssUIAttr Constant
hi link cssTableAttr Constant
hi link cssColorAttr Constant
hi link cssBoxAttr Constant
hi link cssCommonAttr Constant
hi link cssFunctionName Constant
hi link cssRenderProp Type
hi link cssBoxProp cssRenderProp

hi link cssTagName Statement
hi link cssClassName cssTagName
hi link cssIdentifier cssTagName
hi link cssPseudoClass cssTagName
hi link cssPseudoClassId cssTagName

hi cssBraces            guifg=fg            guibg=bg              gui=NONE
hi javaScript           guifg=fg            guibg=NONE
hi link javaScriptFunction Statement
hi link javaScriptMember Statement
hi link javaScriptValue Constant

hi link objcClass Type
hi link cocoaClass objcClass
hi link objcSubclass objcClass
hi link objcSuperclass objcClass
hi link cocoaFunction Function
hi link objcMethodName Identifier
hi link objcMethodArg Normal
hi link objcMessageName Identifier

hi link javaType Statement

hi link cppStatement  Statement


