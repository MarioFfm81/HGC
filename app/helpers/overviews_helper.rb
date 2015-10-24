module OverviewsHelper
    
    def getResult(game)
        resultGroup = game['MatchResults']
        resultGroup.each do |group|
            if group['ResultName'] == 'Endergebnis'
                return group['PointsTeam1'],group['PointsTeam2']
            end
        end
        resultGroup.each do |group|
            if group['ResultName'] != 'Halbzeitergebnis'
                return group['PointsTeam1'],group['PointsTeam2']
            end
        end
        resultGroup.each do |group|
            if group['ResultName'] == 'Halbzeitergebnis'
                return group['PointsTeam1'],group['PointsTeam2']
            end
        end
    end
end
