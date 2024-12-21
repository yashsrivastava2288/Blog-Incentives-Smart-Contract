// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlogIncentives {
    address public owner;
    uint public rewardAmount;

    struct Article {
        string title;
        string content;
        address author;
        uint timestamp;
        bool rewarded;
    }

    Article[] public articles;

    event ArticleSubmitted(uint articleId, string title, address indexed author);
    event RewardDistributed(uint articleId, address indexed author, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(uint _rewardAmount) {
        owner = msg.sender;
        rewardAmount = _rewardAmount;
    }

    function submitArticle(string memory _title, string memory _content) public {
        articles.push(Article({
            title: _title,
            content: _content,
            author: msg.sender,
            timestamp: block.timestamp,
            rewarded: false
        }));

        emit ArticleSubmitted(articles.length - 1, _title, msg.sender);
    }

    function distributeReward(uint _articleId) public onlyOwner {
        require(_articleId < articles.length, "Invalid article ID");
        Article storage article = articles[_articleId];
        require(!article.rewarded, "Reward already distributed");

        article.rewarded = true;
        payable(article.author).transfer(rewardAmount);

        emit RewardDistributed(_articleId, article.author, rewardAmount);
    }

    function depositFunds() public payable onlyOwner {
        // Allow the owner to deposit funds for rewards
    }

    function getArticle(uint _articleId) public view returns (string memory, string memory, address, uint, bool) {
        require(_articleId < articles.length, "Invalid article ID");
        Article memory article = articles[_articleId];
        return (article.title, article.content, article.author, article.timestamp, article.rewarded);
    }

    function getTotalArticles() public view returns (uint) {
        return articles.length;
    }
}
