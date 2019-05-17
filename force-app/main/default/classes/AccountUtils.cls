public class AccountUtils {

    public static List<Account> accountsByState (String abbreviation ){
        List<Account> acc = [Select Id, Name from Account where BillingState =:abbreviation];
        return acc;
    }
}