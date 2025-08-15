function [r,NRMSE] = calculate_metrics(measured_motion, estimated_motion)
    % Calculate NRMSE
    n = length(measured_motion);
    NRMSE = sqrt(sum((measured_motion-estimated_motion).^2)/n)/(max(measured_motion)-min(measured_motion));
    r = corrcoef(measured_motion, estimated_motion);
    r = r(2,1);
%     r=sum((measured_motion-mean(measured_motion)).*(estimated_motion-mean(estimated_motion)))/(sqrt(sum((measured_motion-mean(measured_motion)).^2))*sqrt(sum((estimated_motion-mean(estimated_motion)).^2)));
end