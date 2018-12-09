//import contracts

// Creating and sending the new request to the smart contract
const newRequest = (options) => {
    reutrn Promise.resolve({

    });
}

// If the user wants to trade eth it gets wrapped
const wrapEth = () => {
    reutrn Promise.resolve({
    
    });
}

// Fire an observable that searches for the appropiate auction
const searchAuction = new Observable((observer) => {
    const datasource = new DataSource();
    datasource.ondata = (e) => observer.next(e);
    datasource.onerror = (err) => observer.error(err);
    datasource.oncomplete = () => observer.complete();
    return () => {
        datasource.destroy();
    };
});

// If the user wants to trade eth it gets wrapped
const depositDesiredToken = () => {
    reutrn Promise.resolve({

    });
}

const endOfAuction = new Observable((observer) => {
    const datasource = new DataSource();
    datasource.ondata = (e) => observer.next(e);
    datasource.onerror = (err) => observer.error(err);
    datasource.oncomplete = () => observer.complete();
    return () => {
        datasource.destroy();
    };
});

const sendPushNotificationCompleteTx = (amount, address) => {
    
}