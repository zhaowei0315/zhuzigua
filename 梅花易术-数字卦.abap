*&---------------------------------------------------------------------*
*& Report ZSHUZIGUA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zshuzigua.

TYPES: BEGIN OF typ_mapping,
         index  TYPE n,
         gua    TYPE char2,
         wuxing TYPE char2,
       END OF typ_mapping.
DATA lt_mapping TYPE TABLE OF typ_mapping.

TYPES: BEGIN OF typ_xiangsheng,
         index1 TYPE n,
         index2 TYPE n,
       END OF typ_xiangsheng.
DATA lt_xiangsheng TYPE TABLE OF typ_xiangsheng.

TYPES: BEGIN OF typ_xiangke,
         index1 TYPE n,
         index2 TYPE n,
       END OF typ_xiangke.
DATA lt_xiangke TYPE TABLE OF typ_xiangke.

DATA: BEGIN OF bengua,
        up   TYPE typ_mapping,
        down TYPE typ_mapping,
      END OF bengua.

DATA: BEGIN OF biangua,
        up   TYPE typ_mapping,
        down TYPE typ_mapping,
      END OF biangua.

DATA lv_biaoyan_index TYPE n.

PARAMETERS: num1(3) TYPE n,
            num2(3) TYPE n,
            num3(3) TYPE n.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text01.
SELECTION-SCREEN COMMENT /1(79) text001."每行最多79个字符
SELECTION-SCREEN COMMENT /1(79) text002."每行最多79个字符
SELECTION-SCREEN COMMENT /1(79) text003."每行最多79个字符
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  %_num1_%_app_%-text = `1st Number`.
  %_num2_%_app_%-text = `2nd Number`.
  %_num3_%_app_%-text = `3rd Number`.
  text01 = '用法'.
  text001 = '心中默念提问的问题,并随机想三个三位数字。'.
  text002 = '“三不占”原则：不诚不占、不疑不占、不义不占。'.
  text003 = '同一个问题以第一次占得结果为准，3个月后方可再次占卜。'.

START-OF-SELECTION.

  IF num1 = 0 OR num1 = 0 OR num3 = 0.
    WRITE: / `输入数字不能为零`.
    STOP.
  ENDIF.

  lt_mapping = VALUE #(
        ( index = 1 gua = `乾` wuxing = `金` )
        ( index = 2 gua = `兑` wuxing = `金` )
        ( index = 3 gua = `离` wuxing = `火` )
        ( index = 4 gua = `震` wuxing = `木` )
        ( index = 5 gua = `巽` wuxing = `木` )
        ( index = 6 gua = `坎` wuxing = `水` )
        ( index = 7 gua = `艮` wuxing = `土` )
        ( index = 8 gua = `坤` wuxing = `土` )
      ).

  lt_xiangsheng = VALUE #("相生
        ( index1 = 1 index2 = 6 )"金生水
        ( index1 = 2 index2 = 6 )"金生水
        ( index1 = 3 index2 = 7 )"火生土
        ( index1 = 3 index2 = 8 )"火生土
        ( index1 = 4 index2 = 3 )"木生火
        ( index1 = 5 index2 = 3 )"木生火
        ( index1 = 6 index2 = 4 )"水生木
        ( index1 = 6 index2 = 5 )"水生木
        ( index1 = 7 index2 = 1 )"土生金
        ( index1 = 7 index2 = 2 )"土生金
        ( index1 = 8 index2 = 1 )"土生金
        ( index1 = 8 index2 = 2 )"土生金
      ).

  lt_xiangke = VALUE #("相克
        ( index1 = 1 index2 = 4 )"金克木
        ( index1 = 1 index2 = 5 )"金克木
        ( index1 = 2 index2 = 4 )"金克木
        ( index1 = 2 index2 = 5 )"金克木
        ( index1 = 3 index2 = 1 )"火克金
        ( index1 = 3 index2 = 2 )"火克金
        ( index1 = 4 index2 = 7 )"木克土
        ( index1 = 4 index2 = 8 )"木克土
        ( index1 = 5 index2 = 7 )"木克土
        ( index1 = 5 index2 = 8 )"木克土
        ( index1 = 6 index2 = 3 )"水克火
        ( index1 = 7 index2 = 6 )"土克水
        ( index1 = 8 index2 = 6 )"土克水
      ).

  num1 = num1 MOD 8.
  IF num1 = 0.
    num1 = 8.
  ENDIF.

  num2 = num2 MOD 8.
  IF num2 = 0.
    num2 = 8.
  ENDIF.

  num3 = num3 MOD 6.
  IF num3 = 0.
    num3 = 6.
  ENDIF.

  bengua-up = lt_mapping[ index = num1 ]."本卦
  bengua-down = lt_mapping[ index = num2 ]."本卦

  biangua = bengua.
  IF num3 < 4.
    PERFORM bian_yao USING biangua-down-index num3 CHANGING lv_biaoyan_index.
    biangua-down = lt_mapping[ index = lv_biaoyan_index ]."变卦
  ELSE.
    num3 = num3 - 3.
    PERFORM bian_yao USING biangua-up-index num3 CHANGING lv_biaoyan_index.
    biangua-up = lt_mapping[ index = lv_biaoyan_index ]."变卦
  ENDIF.



  WRITE: / `本卦(目前)`, bengua-up-gua, `/`, bengua-down-gua.
  PERFORM predict USING bengua num3.

  ULINE.
  WRITE: / `变卦(结果)`, biangua-up-gua, `/`, biangua-down-gua.
  PERFORM predict USING biangua num3.



FORM bian_yao USING gua1 TYPE n
                    index TYPE n
                 CHANGING gua2.
  IF index < 1 OR index > 3.
    WRITE: / `变爻索引错误(1~3)`, index.
    STOP.
  ENDIF.

  CLEAR gua2.

  IF gua1 = 1."乾
    IF index = 1.
      gua2 = 5."巽
    ELSEIF index = 2.
      gua2 = 3."离
    ELSEIF index = 3.
      gua2 = 2."兑
    ENDIF.
  ELSEIF gua1 = 2."兑
    IF index = 1.
      gua2 = 6."坎
    ELSEIF index = 2.
      gua2 = 4."震
    ELSEIF index = 3.
      gua2 = 1."乾
    ENDIF.
  ELSEIF gua1 = 3."离
    IF index = 1.
      gua2 = 7."艮
    ELSEIF index = 2.
      gua2 = 1."乾
    ELSEIF index = 3.
      gua2 = 4."震
    ENDIF.
  ELSEIF gua1 = 4."震
    IF index = 1.
      gua2 = 8."坤
    ELSEIF index = 2.
      gua2 = 2."兑
    ELSEIF index = 3.
      gua2 = 3."离
    ENDIF.
  ELSEIF gua1 = 5."巽
    IF index = 1.
      gua2 = 1."乾
    ELSEIF index = 2.
      gua2 = 7."艮
    ELSEIF index = 3.
      gua2 = 6."坎
    ENDIF.
  ELSEIF gua1 = 6."坎
    IF index = 1.
      gua2 = 2."兑
    ELSEIF index = 2.
      gua2 = 8."坤
    ELSEIF index = 3.
      gua2 = 5."巽
    ENDIF.
  ELSEIF gua1 = 7."艮
    IF index = 1.
      gua2 = 3."离
    ELSEIF index = 2.
      gua2 = 5."巽
    ELSEIF index = 3.
      gua2 = 8."坤
    ENDIF.
  ELSEIF gua1 = 8."坤
    IF index = 1.
      gua2 = 4."震
    ELSEIF index = 2.
      gua2 = 6."坎
    ELSEIF index = 3.
      gua2 = 7."艮
    ENDIF.
  ELSE.
    WRITE: / `本卦索引错误(1~8)`, gua1.
    STOP.
  ENDIF.
ENDFORM.

FORM predict USING gua LIKE bengua num3 TYPE n.
  DATA: yong TYPE typ_mapping, "用卦
        ti   TYPE typ_mapping. "体卦

  IF num3 < 4."变爻在下
    yong = gua-down.
    ti = gua-up.
  ELSE."变爻在上
    yong = gua-up.
    ti = gua-down.
  ENDIF.

  IF line_exists( lt_xiangsheng[ index1 = yong-index index2 = ti-index ] ).
    WRITE: / `用生体    大吉(90%)  事必成`.
  ELSEIF yong-wuxing = ti-wuxing.
    WRITE: / `体用比合  次吉(70%)  事易成`.
  ELSEIF line_exists( lt_xiangke[ index1 = ti-index index2 = yong-index ] ).
    WRITE: / `体克用    中吉(40-60%)  事可成`.
  ELSEIF line_exists( lt_xiangsheng[ index1 = ti-index index2 = yong-index ] ).
    WRITE: / `体生用    小凶(30%)  事难成`.
  ELSEIF line_exists( lt_xiangke[ index1 = yong-index index2 = ti-index ] ).
    WRITE: / `用克体    大凶(10%)  事不成`.
  ELSE.
    WRITE: / `错误`.
  ENDIF.
ENDFORM.
