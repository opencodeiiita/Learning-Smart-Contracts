
pragma solidity 0.8.17;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract VedantToken is ERC20 {
  constructor(
    string _name,
    string _symbol,
    uint8 _decimals,
    uint256 _amount
  )
    ERC20(VedantToken, "Tooploox", 18, 21000000)
    public
  {
    require(_amount > 0, "amount has to be greater than 0");
    totalSupply_ = _amount.mul(10 ** uint256(_decimals));
    balances[msg.sender] = totalSupply_;
    emit Transfer(address(0), msg.sender, totalSupply_);
  }
}
