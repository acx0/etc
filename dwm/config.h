/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-terminus-medium-*-*-*-*-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#3f3f3f";
static const char normbgcolor[]     = "#3f3f3f";
static const char normfgcolor[]     = "#dcdccc";
static const char selbordercolor[]  = "#ce2929";
static const char selbgcolor[]      = "#1e2320";
static const char selfgcolor[]      = "#f0dfaf";
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
    /* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",     NULL,       NULL,       0,            True,        -1 },
    { "Iceweasel", NULL,      NULL,       1 << 1,       False,       -1 },
    { "Firefox",  NULL,       NULL,       1 << 1,       False,       -1 },
    { "Emesene",  NULL,       NULL,       1 << 0,       False,       -1 },
    { "Xchat",    NULL,       NULL,       1 << 0,       False,       -1 },
    { "Skype",    NULL,       NULL,       1 << 0,       False,       -1 },
    { "Transmission", NULL,   NULL,       1 << 8,       False,       -1 },
    { "trayer",   NULL,       NULL,       1 << 8,       True,        -1 },
};

/* layout(s) */
static const float mfact      = 0.50; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

#include "bstack.c"
#include "bstackhoriz.c"
static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[]=",      tile },    /* first entry is default */
    { "TTT",      bstack },
    { "===",      bstackhoriz },
    { "[M]",      monocle },
    { "><>",      NULL },    /* no layout function means floating behavior */
    { NULL,       NULL },    /* NULL termination required for layout cycle patch */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-i", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "urxvt", NULL };

#include "movestack.c"
#include "shiftview.c"
static Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_r,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
    { MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },
    { MODKEY,                       XK_h,      shiftview,      {.i = -1 } },
    { MODKEY,                       XK_l,      shiftview,      {.i = +1 } },
    { MODKEY,                       XK_Left,   setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_Right,  setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    /*{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },*/
    /*{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },*/
    /*{ MODKEY,                       XK_space,  setlayout,      {0} },*/
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[sizeof(layouts) / sizeof(layouts[0]) - 2]} },
    { MODKEY,                       XK_space,  nextlayout,     {0} },
    { MODKEY|ShiftMask,             XK_space,  prevlayout,     {0} },
    { MODKEY|ControlMask,           XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
