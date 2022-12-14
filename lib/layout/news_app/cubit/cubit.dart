import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_app/cubit/states.dart';
import 'package:news_app/modules/news_app/business/business_screen.dart';
import 'package:news_app/modules/news_app/science/science_screen.dart';
import 'package:news_app/modules/news_app/sports/sports_screen.dart';
import 'package:news_app/shared/network/local/cashe_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';


class NewsCubit extends Cubit<NewsStates>{
  NewsCubit():super(NewsInitialState());
  static NewsCubit get(context)=>BlocProvider.of(context);
  int currentIndex=0;
  List<BottomNavigationBarItem> bottomItems=[
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',


    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',


    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',


    ),

  ];
  List<Widget> screens=[
    BusinessScreeen(),
    SportsScreeen(),
    ScienceScreeen(),

  ];
  void changeBottomNavBar(int index){
    currentIndex=index;
    if(index==1)
      getSports();
    if(index==2)
      getScience();
    emit(NewsBottomNavState());
  }
  List<dynamic>business=[];
  void getBusiness(){
    emit(NewsGetBusinessLoadingState());
    if(business.length==0){
    DioHelper.getData(

        url: 'v2/top-headlines',
        query: {
          'country':'eg',
          'category':'business',
          'apiKey':'ca93d9f48480498c989bdf3bd24ee895',

        }
    ).then((value) {
      //print(value?.data['articles'][0]['title']);
      business=value?.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(NewsGetBusinessErrorsState(error.toString()));
    });}else{
      emit(NewsGetBusinessSuccessState());
    }

  }


  List<dynamic>sports=[];
  void getSports(){
    emit(NewsGetSportsLoadingState());
    if(sports.length==0){
      DioHelper.getData(

          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'sports',
            'apiKey':'ca93d9f48480498c989bdf3bd24ee895',
            //https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=ca93d9f48480498c989bdf3bd24ee895
            //https://newsapi.org/v2/top-headlines?country=eg$category=business$apiKey=65f7f556ec76449fa7dc7c0069f040ca
          }
      ).then((value) {
        //print(value?.data['articles'][0]['title']);
        sports=value?.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }).catchError((error)
      {
        print(error.toString());
        emit(NewsGetSportsErrorsState(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessState());
    }


  }

  List<dynamic>science=[];
  void getScience(){
    emit(NewsGetScienceLoadingState());
    if(science.length==0){
      DioHelper.getData(

          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'science',
            'apiKey':'ca93d9f48480498c989bdf3bd24ee895',
            //https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=ca93d9f48480498c989bdf3bd24ee895
            //https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=ca93d9f48480498c989bdf3bd24ee895
            //https://newsapi.org/v2/top-headlines?country=eg$category=business$apiKey=65f7f556ec76449fa7dc7c0069f040ca
          }
      ).then((value) {

        science=value?.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((error)
      {
        print(error.toString());
        emit(NewsGetScienceErrorsState(error.toString()));
      });

    }else{
      emit(NewsGetScienceSuccessState());

    }



}

  List<dynamic>search=[];
  void getSearch(String value){


    emit(NewsGetSearchLoadingState());

    DioHelper.getData (

        url: 'v2/everything',
        query: {

          'q':'$value',
          'apiKey':'ca93d9f48480498c989bdf3bd24ee895',
          //https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=ca93d9f48480498c989bdf3bd24ee895
          //https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=ca93d9f48480498c989bdf3bd24ee895
          //https://newsapi.org/v2/top-headlines?country=eg$category=business$apiKey=65f7f556ec76449fa7dc7c0069f040ca
        }
    ).then((value) {
      //print(value?.data['articles'][0]['title']);
      search=value?.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(NewsGetSearchErrorsState(error.toString()));
    });

  }


  bool isDark=false;
  //ThemeMode appMode=ThemeMode.light,
  void changeAppMode({bool? fromShard}) {
    if(fromShard!=null)
    {
      isDark=fromShard;
      emit(NewsChangeModeState());
    }

    else
    {
      isDark = !isDark;
      CasheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(NewsChangeModeState());

      }
      );
    }

  }

}