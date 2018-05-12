@Grab(group='org.apache.commons', module='commons-lang3', version='3.7')
import org.apache.commons.lang3.StringUtils

if (new File('/home/groovy/.groovy/grapes').listFiles().size() == 0) {
    System.exit 1
} else {
    System.exit 0
}
