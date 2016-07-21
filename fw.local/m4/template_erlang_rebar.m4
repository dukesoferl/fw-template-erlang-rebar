AC_DEFUN([FW_TEMPLATE_ERLANG_REBAR],
[
  FW_ERL_APP_NAME=${FW_ERL_APP_NAME-${FW_PACKAGE_NAME}}
  FW_SUBST_PROTECT(FW_ERL_APP_NAME)

  AC_REQUIRE([FW_TEMPLATE_ERLANG_REBAR_ENABLE_ERLRC])
  echo "$FW_ERL_APP_NAME" | perl -ne 'm/-/ && exit 1; exit 0'

  if test $? != 0
    then
      AC_MSG_ERROR([sorry, FW_ERL_APP_NAME ($FW_ERL_APP_NAME) cannot contain dashes, if you haven't set FW_ERL_APP_NAME its probably using the default for FW_ERL_APP_NAME which is FW_PACKAGE_NAME ($FW_PACKAGE_NAME), so modify fw-pkgin/config to set FW_ERL_APP_NAME])
      exit 1
    fi

  AC_ARG_VAR([ERLAPPDIR],
             [application directory (default: GUESSED_ERLANG_PREFIX/erlang/lib/$FW_ERL_APP_NAME-$FW_PACKAGE_VERSION)])

  if test "x$ERLAPPDIR" = x
    then
      AC_MSG_CHECKING([for erlang library prefix...])

      guessederlangprefix=`erl -noshell -noinput -eval 'io:format ("~s", [[ code:lib_dir () ]])' -s erlang halt`

      AC_MSG_RESULT([${guessederlangprefix}])

      ERLAPPDIR="${guessederlangprefix}/\$(FW_ERL_APP_NAME)-\$(FW_PACKAGE_VERSION)"
    fi

  AC_ARG_VAR([ERLDOCDIR],
             [documentation directory (default: $datadir/doc/erlang-doc-html/html/lib/$FW_ERL_APP_NAME-$FW_PACKAGE_VERSION/doc/html)])

  if test "x$ERLDOCDIR" = x
    then
      ERLDOCDIR="\$(datadir)/erlang/lib/\$(FW_ERL_APP_NAME)-\$(FW_PACKAGE_VERSION)/doc/html"
    fi

  AC_ARG_VAR([ERLRCDIR],
             [erlrc configuration directory (default: /etc/erlrc.d)])

  if test "x$ERLRCDIR" = x
    then
      ERLRCDIR="/etc/erlrc.d"
    fi

  AC_CHECK_PROG([ERLC], [erlc], [erlc])

  if test "x$ERLC" = x
    then
      AC_MSG_ERROR([cant find erlang compiler])
      exit 1
    fi

  AC_ARG_VAR(ERLC, [erlang compiler])

  AC_MSG_CHECKING([looking for rebar])

  AC_PATH_PROG([REBAR], [rebar], ,[.:$PATH])
  if test "x$REBAR" = x
  then
    AC_MSG_ERROR([cant find rebar])
    exit 1
    fi
    AC_ARG_VAR(REBAR, [rebar build tool])
  AC_SUBST([REBAR])

  AC_MSG_CHECKING([rebar supports dialyzer])

  if $REBAR dialyze 2> /dev/null 1> /dev/null ; then
    AC_MSG_RESULT([yes])
  else
    SUPPORT_DIALYZE=1
    AC_MSG_RESULT([no])
  fi
  AC_SUBST([SUPPORT_DIALYZE])

  FW_SUBST_PROTECT([FW_EDOC_OPTIONS])
  FW_SUBST_PROTECT([FW_LEEX_OPTIONS])
  FW_SUBST_PROTECT([FW_YECC_OPTIONS])
  FW_SUBST_PROTECT([FW_WRAP_GITPATH])
  FW_SUBST_PROTECT([FW_WRAP_GITNAME])
  FW_SUBST_PROTECT([FW_WRAP_GITTAG])
  FW_SUBST_PROTECT([NO_DIALYZE])
  FW_SUBST_PROTECT([NO_EUNIT])
])
