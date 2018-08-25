pragma solidity ^0.4.24;

contract Ownable {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    if (msg.sender != owner) {
      throw;
    }
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }
}

contract Lucky is Ownable {
    uint256 public balances = 0;
    uint32 public limit = 2;
    uint32 public count = 0;
    uint public random_number;
    address public lastWinner;
    
    struct participant {
        address nameaddress;
    }
    
    mapping(uint => participant) people;

    
    function random() internal returns (uint){
        uint256 lastBlockNumber = block.number - 1;
        uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
        
        // This turns the input data into a 100-sided die
        // by dividing by ceil(2 ^ 256 / 100).
        uint256 FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
        uint256 seed = uint256(uint256(hashVal) / FACTOR) + 1;
        return random_number = uint(sha3(block.blockhash(block.number-1), seed ))%2;
       
    }
    function withdraw() internal {
        require(count == 0);
        uint winner = random();
        lastWinner = people[winner].nameaddress;
        uint fee = balances/100;
        balances -= fee;
        address(owner).transfer(fee);
        address(people[winner].nameaddress).transfer(balances);
        balances = 0;
    }

    function deposit(uint256 amount) payable public {
        require(msg.value == amount);
        require(count < limit);
        if(count > 0)
        {
            require(msg.value == balances);
        }
        people[count].nameaddress = msg.sender;
        balances += amount;
        if(count == 1)
        {
            count = 0;
            withdraw(); 
        }else{
            count++;
        }
        
       
        // nothing else to do!
    }
    
    function withdrawSelf() public{
        require(count == 1);
        count = 0;
        balances = 0;
        address(msg.sender).transfer(this.balance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
        // return this.balance;
    } 
    function getZero() public view returns (address){
        return people[0].nameaddress;
    }
    function getOne() public view returns (address){
        return people[1].nameaddress;
    }

}
