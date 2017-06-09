package com.spring.board.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.aop.ThrowsAdvice;

import com.spring.board.model.BoardVO;
import com.spring.board.model.CommentVO;
import com.spring.member.model.MemberVO;

// Service 단 인터페이스 선언

public interface InterBoardService {
	
	List<String> getImgfilenameList();	// 이미지 파일명 가져오기
	
	int loginEnd(HashMap<String,String> map);	// 로그인 여부 알아오기
	
	MemberVO getLoginMember(String userid); // 로그인한 회원에 대한 정보 가져오기
	
	int add(BoardVO boardvo);	// 글쓰기 ( 파일첨부 X )
	
//	List<BoardVO> boardList();	// 전체 글 목록 보여주기 ( 검색어 X )
	
	List<BoardVO> boardList(HashMap<String,String> map); // 전체 글 목록 보여주기 ( 검색어 O )
	
	BoardVO getView(String seq);	// 글 조회수 1 증가 후 1개 글 보여주기 
	
	BoardVO getViewWithNoCount(String seq);	// 글 조회수 증가 없이 1개 글 보여주기

	int edit(HashMap<String, String> map); // 1개 글 수정하기
	
//	int del(HashMap<String, String> map); // 1개 글 삭제하기
	
	int del(HashMap<String, String> map) throws Throwable; // 1개 글 삭제하기
	
	int addComment(CommentVO cvo) throws Throwable;  // 댓글쓰기
	
	List<CommentVO> getCommentList(String seq); // 댓글 보여주기
	
	int getTotalCount(HashMap<String,String> map);	// 전체 게시물 건 수 구하기
	
	int add_withFile(BoardVO boardvo);	// 글쓰기 ( 파일 첨부 O )
	
	List<HashMap<String,String>> searchWordCompleteList(HashMap<String,String> map);	//	검색어 입력시 자동글완성하기
	
	
}
