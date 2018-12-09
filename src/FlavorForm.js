import React from 'react';
import ReactDOM from 'react-dom';
const rp = require('request-promise-native');


class FlavorForm extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
          tokenA: 'default',
          tokenB: 'default',
          amount: ''
        };
    }
  
    handleChangeFirst = (event) =>  {
        var tokenAIndex = document.getElementById("tokenA").options.selectedIndex
        var tokenBIndex = document.getElementById("tokenB").options.selectedIndex

        var tokenA= document.getElementById("tokenA")
        var tokenB = document.getElementById("tokenB");
        this.setState({ tokenA: tokenA[tokenAIndex].value })
        this.setState({ tokenB: tokenB[tokenBIndex].value })
    }
    
    getLastPrice() {
        rp("https://dutchx.d.exchange/api/v1/markets/WETH-RDN/closing-prices?count=10")
        .then(function (result) {
            var parsed = JSON.stringify(result)
            if(result.length > 0){
                alert(result)
            } else {
                alert("There is no price range available")
            }
        })
        .catch(function (err) {
            console.log(err)
        });
    }

    async getTransactionFee() {
        return rp("https://dutchx.d.exchange/api/v1/accounts/0x4e69969d9270ff55fc7c5043b074d4e45f795587/current-fee-ratio")
        .then(function (result) {
            if(result.length > 0){
                console.log(result)
                alert(result)

            } else {
                alert("There is no price range available")
            }
        })
        .catch(function (err) {
            console.log(err)
        });
    }

    render() {
      return (
        <form >
        <div display="block">
        <div class="child">
          <label class="child">
            What token would you like to exchange:
            <select id="tokenA" value={this.state.value} onChange={this.handleChangeFirst}>
              <option value="WETH"> WETH </option>
              <option value="RDN"> RDN </option>
            </select>
          </label>
          <label class="child">
            What token would you exchange it for:
            <select id="tokenB" value={this.state.value} onChange={this.handleChangeFirst} onChange={this.getLastPrice}>
              <option value="WETH"> WETH </option>
              <option value="RDN"> RDN </option>
            </select>
          </label>
          </div>
          <div class="child">
            <button > <label onClick={this.getTransactionFee}>Get Transaction Fee </label> </button>
            <button> Don't use Owl </button>
            <button> Use Owl to pay the fee </button>
          </div>
          <label>Amount of WETH:</label>
            <input          
                value={ this.state.amount }
                onChange={ event => this.setState({ amount: event.target.value }) }
                placeholder="Enter the amount..."
                />            
          </div>
          <button> Submit Transaction </button>
        </form>
      );
    }
  }

  export default FlavorForm