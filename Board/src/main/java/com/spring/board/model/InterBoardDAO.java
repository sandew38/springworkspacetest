package com.spring.board.model;

import java.util.HashMap;
import java.util.List;

import com.spring.member.model.MemberVO;

// model 단 (DAO)의 인터페이스 생성

public interface InterBoardDAO {

	List<String> getImgfilenameList();	// 이미지 파일명 가져오기
	
	int loginEnd(HashMap<String,String> map);// 로그인 여부 알아오기
	
	MemberVO getLoginMember(String userid); // 로그인한 사용자의 정보 담아두기 
	
	int add(BoardVO boardvo);	// 글쓰기 ( 파일첨부 X )
	
//	List<BoardVO> boardList();	// 전체 글 목록 보여주기 ( 검색어 X )
	
	List<BoardVO> boardList(HashMap<String,String> map);	// 전체 글 목록 보여주기 ( 검색어 O )
	
	void setAddReadCount(String seq); // 글 조회수 1 증가
	
	BoardVO getView(String seq);	// 선택한 글 한 개 보여주기
	
	boolean checkPW(HashMap<String, String> map);	// 수정하려는 글의 암호와 입력받은 암호가 일치하는지 확인하기
	
	int updateContent(HashMap<String, String> map); // 글 수정하기 
	
	int updateStatus(HashMap<String, String> map); // 글 삭제하기 
	
	int isExistsComment(HashMap<String, String> map); // 원게시글에 달린 댓글이 있는지 없는지를 확인하기
	
	int delComment(HashMap<String, String> map); // 원게시글에 달린 댓글들 삭제하기	
	
	int addComment(CommentVO cvo);	// 댓글쓰기
	
	int updateCommentCount(String parentSeq);	// 댓글쓰기 후 댓글 수 업데이트하기
	
	List<CommentVO> getCommentList(String parentSeq); // 댓글 내용 보여주기 
	
	int getTotalCount(HashMap<String,String> map);	// 전체 게시물 건 수 구하기
	
	int getGroupMaxno();	// spring_tblBoard에서 groupno 컬럼의 최댓값 구하기
	
	int add_withFile(BoardVO boardvo);	// 글쓰기 ( 파일 첨부 O )
	
	List<HashMap<String,String>> searchWordCompleteList(HashMap<String,String> map);	//	검색어 입력시 자동글완성하기
	
} // end of public interface InterBoardDAO ----
