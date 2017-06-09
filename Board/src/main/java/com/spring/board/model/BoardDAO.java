package com.spring.board.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.member.model.MemberVO;

// ==== #28. DAO 선언 ====

@Repository
public class BoardDAO implements InterBoardDAO {

// ==== #29. 의존객체 주입하기 (DI : Dependency Injection) ====
	
	@Autowired
	private SqlSessionTemplate sqlsession;

// ==== #42. 메인 페이지용 이미지 파일 이름을 가져오는 모델단 public List<String> getImgfilenameList() 메소드 생성하기
//		이미지 파일명 가져오기
	@Override
	public List<String> getImgfilenameList() {
		
		List<String> list = sqlsession.selectList("board.getImgfilenameList");
		
		return list;
		
	}

//	==== #47. 로그인 여부 알아오기
	
	@Override
	public int loginEnd(HashMap<String, String> map) {

		int n = sqlsession.selectOne("board.loginEnd", map);
		
		return n;
	}

//	==== #50. 로그인한 사용자의 정보 담아두기 	
	@Override
	public MemberVO getLoginMember(String userid) {
		
		MemberVO loginuser = sqlsession.selectOne("board.getLoginMember", userid);		
		
		return loginuser;
		
	}

//	==== #57. 글쓰기를 해주는 int add(BoardVO boardvo) 메소드 만들기
	@Override
	public int add(BoardVO boardvo) {

		int n = sqlsession.insert("board.add", boardvo);
		
		return n ;
	}

/*	==== #61. 전체 글 목록을 보여주는 List<BoardVO> boardList() 메소드 만들기
	@Override
	public List<BoardVO> boardList() {

		List<BoardVO> boardList = sqlsession.selectList("board.boardList");
		
		return boardList;
		
	}
*/
	
//	==== #106. 전체 글 목록을 보여주는 List<BoardVO> boardList() 메소드 만들기
//			검색어 검색 기능이 포함된 
	@Override
	public List<BoardVO> boardList(HashMap<String, String> map) {

		List<BoardVO> boardList = sqlsession.selectList("board.boardList", map);
		
		return boardList;
		
	}
	
	
	
	
	
//	==== #65. 선택한 글의 조회수를 1 올려주는 메소드 
	@Override
	public void setAddReadCount(String seq) {

		sqlsession.update("board.setAddReadCount", seq);
		
	}

//	==== #65. 선택한 한 개의 글을 보여주는 메소드
	@Override
	public BoardVO getView(String seq) {
		
		BoardVO boardvo = sqlsession.selectOne("board.getView", seq);
		
		return boardvo;
		
	}

//	==== #73. 수정하려는 글의 암호와 입력받은 암호가 일치하는지 확인하는 메소드
	@Override
	public boolean checkPW(HashMap<String, String> map) {

		int n = sqlsession.selectOne("board.checkPW", map);
		
		boolean bool = false;
		
		if (n > 0)
		{
			bool = true;
		}
		else 
		{
			bool = false;			
		}
		
		return bool;
		
	}

	
//	==== #73. 글을 수정해주는 메소드 
	@Override
	public int updateContent(HashMap<String, String> map) {

		int n = sqlsession.update("board.updateContent", map);
		
		return n;
		
	}

//	==== 글을 삭제해주는 메소드 
	@Override
	public int updateStatus(HashMap<String, String> map) {
		
		int n = sqlsession.update("board.updateStatus", map);
		
		return n;
	}

//	==== #86. 댓글 쓰기
	@Override
	public int addComment(CommentVO cvo) {
		
		int n = sqlsession.insert("board.addComment", cvo);
		
		return n;
	}

// ==== #86. 댓글 쓰기 후 댓글 갯수 업데이트해주는 메소드 (spring_tblBoard)
	@Override
	public int updateCommentCount(String parentSeq) {
		
		int n = sqlsession.update("board.updateCommentCount", parentSeq);
		
		return n ;
	}

	
//	==== #91. 댓글 내용 보여주기
	@Override
	public List<CommentVO> getCommentList(String parentSeq) {
	
		List<CommentVO> commentList = sqlsession.selectList("board.commentList", parentSeq);
		
		return commentList;
		
	}
	
	
//	==== #99. 원게시글에 딸린 댓글이 있는지 없는지를 확인하기 =====
	@Override
	public int isExistsComment(HashMap<String, String> map) {
		
		int count = sqlsession.selectOne("board.isExistsComment", map); 
		return count; 
		
	}

	
//	==== #100. 원게시글에 딸린 댓글들 삭제하기 =====	
	@Override
	public int delComment(HashMap<String, String> map) {
		
		int result = sqlsession.update("board.delComment", map);
		return result;
		
	}

	
// ==== #113. 총 게시물 건 수 구하기 
// 총 게시물 건 수는 검색 조건이 없을 때와 있을 때로 나뉜다.
	
	@Override
	public int getTotalCount(HashMap<String, String> map) {

		int count = sqlsession.selectOne("board.getTotalCount", map);
		return count;
		
	}

//	==== #122. spring_tblBoard에서 groupno 컬럼의 최댓값 구하기
	@Override
	public int getGroupMaxno() {

		int max = sqlsession.selectOne("board.getGroupMaxno");
		
		return max ;
		
	}
	
	
//	==== #138. 글쓰기를 해주는 int add(BoardVO boardvo) 메소드 만들기
//					첨부 파일이 있는 경우
	@Override
	public int add_withFile(BoardVO boardvo) {

		int n = sqlsession.insert("board.add_withFile", boardvo);
		
		return n ;
	}


//	====	#150. Ajax로 검색어 입력시 자동글 완성하기 ⑤	====
	@Override
	public List<HashMap<String, String>> searchWordCompleteList(HashMap<String, String> map) {

		List<HashMap<String, String>> List = sqlsession.selectList("board.searchWordCompleteList", map);
		
		return List;
		
	}
	
} // end of public class BoardDAO implements InterBoardDAO ----
