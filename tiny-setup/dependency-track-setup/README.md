    
# pom 文件里面添加下面这段，然后使用 verify 会生成 sbom

    <!-- *********************** dependency track begin *********************** -->
    <plugin>
        <groupId>org.cyclonedx</groupId>
        <artifactId>cyclonedx-maven-plugin</artifactId>
        <version>2.7.0</version>
        <executions>
            <execution>
                <phase>verify</phase>
                <goals>
                    <goal>makeAggregateBom</goal>
                </goals>
            </execution>
        </executions>
        <configuration>
            <projectType>library</projectType>
            <schemaVersion>1.4</schemaVersion>
            <includeBomSerialNumber>true</includeBomSerialNumber>
            <includeCompileScope>true</includeCompileScope>
            <includeProvidedScope>true</includeProvidedScope>
            <includeRuntimeScope>true</includeRuntimeScope>
            <includeSystemScope>true</includeSystemScope>
            <includeTestScope>false</includeTestScope>
            <includeLicenseText>false</includeLicenseText>
            <outputReactorProjects>true</outputReactorProjects>
            <outputFormat>all</outputFormat>
            <outputName>bom</outputName>
        </configuration>
    </plugin>
    <!-- *********************** dependency track end *********************** -->