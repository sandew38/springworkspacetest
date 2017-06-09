package com.spring.board.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.board.model.BoardDAO;
import com.spring.board.model.BoardVO;
import com.spring.board.model.CommentVO;
import com.spring.member.model.MemberVO;

//	==== #30. Service 선언 ====

@Service
public class BoardService implements InterBoardService {

//	==== #31. 의존객체 주입하기 (DI : Dependency Injection) ====
	
	@Autowired
	private BoardDAO bdao;

	
//	==== #41. 메인 페이지용 이미지 파일 이름을 가져오는 서비스단 public List<String> getImgfilenameList() 메소드 생성하기
// 			이미지 파일명 가져오기
	@Override
	public List<String> getImgfilenameList() {
		
		 List<String> list = bdao.getImgfilenameList();
		 
		 return list;
		 
	}

//	==== #46. 로그인 여부 알아오기 
	@Override
	public int loginEnd(HashMap<String, String> map) {

		int n = bdao.loginEnd(map);
		
		return n;
		
	}
	
//	==== #49. 로그인한 사용자의 정보 담아두기 
	@Override
	public MemberVO getLoginMember(String userid) {
		
		MemberVO loginuser = bdao.getLoginMember(userid);
		
		return loginuser;
	}

//	==== #56. 글쓰기를 해주는 서비스단 int add(BoardVO boardvo)
	@Override
	public int add(BoardVO boardvo) {
		
	/*	==== #121. 글쓰기가 그냥 글쓰기인지 답변글 쓰기인지 구분하여 
					spring_tblBoard 테이블에 insert를 해주어야 한다.
		
		그냥 글쓰기라면 spring_tblBoard 테이블의 groupno 컬럼 값은
		groupno 컬럼의 max값 + 1 로 해야하고,		
		답변 글쓰기라면 넘겨받은 groupno 값을 그대로 insert 해주어야 한다.
	*/
	
	//	그냥 글쓰기인지, 답변글 쓰기인지 확인하기
		if( boardvo.getFk_seq() == null || boardvo.getFk_seq().trim().isEmpty() )
		{	// 그냥 글쓰기
			int groupno = bdao.getGroupMaxno() +1;
			boardvo.setGroupno(String.valueOf(groupno));
			
			System.out.println("groupno : " + groupno);
			System.out.println("Fk_seq : " + boardvo.getFk_seq());
		}
		
		int n = bdao.add(boardvo);
				
		return n ;
	}

/*	==== #60. 전체 글 목록을 보여주는 서비스단 List<BoardVO> boardList()
	@Override
	public List<BoardVO> boardList() {
		
		List<BoardVO> boardList = bdao.boardList();
		
		return boardList;
		
	} // end of List<BoardVO> boardList() ----
*/

	
//	==== #105. 검색 기능이 포함된 글 목록을 보여주는 메소드
//	경우에 따라서는 검색 결과를 보여주기도 한다.
	@Override
	public List<BoardVO> boardList(HashMap<String, String> map) {
		
		List<BoardVO> boardList = bdao.boardList(map);
		
		return boardList;
		
	}
	
	
	
//	==== #64. 선택한 글 한 개를 보여주는 서비스단 BoardVO getView(String seq) 	
//				★	조회수 업데이트 먼저 해주어야한다	★	
	@Override
	public BoardVO getView(String seq) {

		bdao.setAddReadCount(seq);
		// 조회수 증가
		
		BoardVO boardvo = bdao.getView(seq);
		
		return boardvo;
		
	} // end of BoardVO getView(String seq) ----

//	==== #69. 선택한 글 한개를 보여주는 서비스단 BoardVO getViewWithNoCount(String seq)
//			★	조회수 증가 없이	★
	@Override
	public BoardVO getViewWithNoCount(String seq) {

		BoardVO boardvo = bdao.getView(seq);
				
		return boardvo;
		
	} // end of BoardVO getViewWithNoCount(String seq) ----

//	==== #72. 1개의 글 수정하기 	
	@Override
	public int edit(HashMap<String, String> map) {

		// 폼에서 입력받은 글 번호 및 암호가
		// DB에 저장된 글 번호의 암호와 같은 지 확인한다. 
		// 일치하면 true 반환, 불일치하면 false를 반환한다. 
		
		boolean bool = bdao.checkPW(map);
		
		int n = 0;
		
		if (bool)
		{	// 암호가 일치할 경우
			n = bdao.updateContent(map);
		}
		
		return n;
		
	}

//	==== #72. 1개의 글 삭제하기
	@Override
//	public int del(HashMap<String, String> map) {
		// 폼에서 입력받은 글 번호 및 암호가
		// DB에 저장된 글 번호의 암호와 같은 지 확인한다. 
		// 일치하면 true 반환, 불일치하면 false를 반환한다. 
	
	
// ==== #96. Transaction 처리를 위해서 아래와 같이 해준다.	
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int del(HashMap<String, String> map) throws Throwable {
		
		boolean checkPW = bdao.checkPW(map);
		
		int result1 = 0;
		int result2 = 0;
		int count = 0;
		int n = 0;
		
		if(checkPW)
		{	// 암호가 일치할 경우
			
//	==== #97. 원래의 게시물에 달린 댓글이 있는지 확인한다.			
			count = bdao.isExistsComment(map);
			
			result1 = bdao.updateStatus(map);
			
			if (count > 0)
			{

//	==== #98. 원래의 게시물에 달린 댓글을 삭제한다.				
			result2 = bdao.delComment(map);
			
			}
			
		}
		
		if( (result1 > 0 && (count > 0 && result2 >0) ) ||	// 원래의 글의 status를 바꿔주었고 댓글이 달려있는데 그것도 지우기에 성공한 경우!
			(result1 > 0 && count == 0)	) // 원래의 글의 status를 바꾸어주었고 댓글이 달려있지 않은 경우!
		{ 
			n = 1; // 성공!
		}
		
		
		return n;
	}

	
/*	==== #85. 댓글쓰기 
	
	spring_tblComment 테이블에 insert 한 후에
	spring_tblBoard 테이블에 commentCount 컬럼이 1증가 되도록 요청한다.
	즉, 2개 이상의 DML 처리를 해야 하므로 Transaction 처리를 해야한다.
	>>> 트랜잭션 처리를 해야할 메소드에 @Transactional 어노테이션을 설정하면 된다.
	
	rollbackFor={Throwable.class} 은 롤백을 해야할 범위를 말하는데 
	Throwable.class 은 error 및 exception 을 포함한 최상위 루트이다. 
	즉, 해당 메소드 실행시 발생하는 모든 error 및 exception 에 대해서 롤백을 하겠다는 말이다.
	
*/	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation= Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int addComment(CommentVO cvo) throws Throwable {
		
		int n = 0;
		
		n = bdao.addComment(cvo);
		
		int result = 0;
		
		if(n == 1)
		{
			result = bdao.updateCommentCount(cvo.getParentSeq());
		}
		
		return result;
	}

	
//	==== #90. 댓글 보여주기 
	@Override
	public List<CommentVO> getCommentList(String seq) {
		
		List<CommentVO> commentList = bdao.getCommentList(seq);
		
		return commentList;
		
	}

// ==== #112. 총 게시물 건 수 구하기 
// 총 게시물 건 수는 검색 조건이 없을 때와 있을 때로 나뉜다.
	
	@Override
	public int getTotalCount(HashMap<String, String> map) {

		int n = 0;
		
		n = bdao.getTotalCount(map);
		
		return n;
		
	}

	
// ==== #137. 파일첨부가 있는 글쓰기 	
	
	@Override
	public int add_withFile(BoardVO boardvo) {

	/*	==== #121. 글쓰기가 그냥 글쓰기인지 답변글 쓰기인지 구분하여 
					spring_tblBoard 테이블에 insert를 해주어야 한다.
		
		그냥 글쓰기라면 spring_tblBoard 테이블의 groupno 컬럼 값은
		groupno 컬럼의 max값 + 1 로 해야하고,		
		답변 글쓰기라면 넘겨받은 groupno 값을 그대로 insert 해주어야 한다.
	*/
	
	//	그냥 글쓰기인지, 답변글 쓰기인지 확인하기
		if( boardvo.getFk_seq() == null || boardvo.getFk_seq().trim().isEmpty() )
		{	// 그냥 글쓰기
			int groupno = bdao.getGroupMaxno() +1;
			boardvo.setGroupno(String.valueOf(groupno));
			
			System.out.println("groupno : " + groupno);
			System.out.println("Fk_seq : " + boardvo.getFk_seq());
		}
		
		int n = bdao.add_withFile(boardvo);	// 첨부 파일이 있는 경우 
				
		return n ;

	}

//	====	#149. Ajax로 검색어 입력시 자동글 완성하기 ④	====
	@Override
	public List<HashMap<String, String>> searchWordCompleteList(HashMap<String, String> map) {

		System.out.println("★★★ : "+ map.get("search"));
		
		if(!map.get("search").trim().isEmpty())
		{
			List<HashMap<String, String>> List = bdao.searchWordCompleteList(map);
			 
			return List;			
		}
		else
		{
			return null;
		}
		
	}


	
	
	
	
	
	
	
} // end of public class BoardService implements InterBoardService ----
